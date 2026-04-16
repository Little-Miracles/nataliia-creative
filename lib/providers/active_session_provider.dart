import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_body_life/providers/custom_workout_provider.dart';
import 'package:smart_body_life/providers/metrics_provider.dart';
import 'package:smart_body_life/providers/workout_library_provider.dart';
import '../screens/workout_data_models.dart';

class ExerciseSet {
  final double weight;
  final int reps;
  final Duration workDuration; 
  final Duration restDuration;
  final DateTime timestamp;
  final double kcal; // Добавляем ячейку для хранения честной цифры

  ExerciseSet({
    required this.weight,
    required this.reps,
    required this.workDuration,
    required this.restDuration,
    required this.timestamp,
    required this.kcal, // Теперь это обязательный элемент записи
  });
}

enum ActiveMode { evolution, protocol, running, none }

class ActiveSessionProvider with ChangeNotifier {
  final Stopwatch _totalStopwatch = Stopwatch(); 
  final Stopwatch _setStopwatch = Stopwatch();   
  Timer? _totalUiTimer;
  Timer? _restTimer;

  int _restSecondsRemaining = 0;
  bool _isResting = false;
  bool _isManualRest = false;
  
  final Map<String, List<ExerciseSet>> _sessionLog = {};
  final List<Exercise> _evolutionBasket = [];
  final List<Exercise> _protocolBasket = [];
  final List<SavedWorkout> _savedWorkouts = [];
  SavedWorkout? _currentRunningWorkout;

  ActiveMode _currentMode = ActiveMode.none;
  TabController? _mainTabController;
  TabController? _tabController;

  ActiveMode get currentMode => _currentMode;
  bool get isResting => _isResting;
  bool get isManualRest => _isManualRest;
  int get restSecondsRemaining => _restSecondsRemaining;
  Duration get totalTime => _totalStopwatch.elapsed;
  Map<String, List<ExerciseSet>> get sessionLog => _sessionLog;
  bool get isWorkoutActive => _totalStopwatch.elapsedTicks > 0; 
  bool get isTimerRunning => _totalStopwatch.isRunning;
  
  List<Exercise> get evolutionExercises => _evolutionBasket;
  List<Exercise> get protocolExercises => _protocolBasket;
  List<SavedWorkout> get savedWorkouts => _savedWorkouts;
  SavedWorkout? get currentRunningWorkout => _currentRunningWorkout;

  void setActiveMode(ActiveMode mode) {
    _currentMode = mode;
    notifyListeners();
  }

  void startSession(SavedWorkout workout) {
    _stopRestEngine();
    _currentRunningWorkout = workout;
    _currentMode = ActiveMode.running;
    _isResting = false;
    _totalStopwatch.reset();
    _totalStopwatch.start(); 
    _startTotalUiTimer();
    _sessionLog.clear();
    notifyListeners();
  }

  void startLiveWorkout() {
    clearWorkout(); // Сначала полностью очищаем текущее состояние
    
    // Создаем ID, который никогда не повторится (метка времени в мс)
    final String uniqueId = "LIVE_${DateTime.now().millisecondsSinceEpoch}";

    _currentRunningWorkout = SavedWorkout(
      id: uniqueId,
      name: "NEW SESSION",
      exercises: [],
      sessionResults: [],
    );
    
    _totalStopwatch.reset();
    _currentMode = ActiveMode.running;
    notifyListeners();
  }

  void startWorkoutFromTemplate(String name, List<Exercise> exercises, {String? existingId}) {
    // Даже если пришел existingId (ID папки), мы создаем уникальный ID для текущего прогона
    final String sessionUniqueId = existingId ?? DateTime.now().millisecondsSinceEpoch.toString();
    
    _currentRunningWorkout = SavedWorkout(
      id: sessionUniqueId,
      name: name,
      exercises: List.from(exercises), 
      sessionResults: [],
    );
    
    _totalStopwatch.reset(); 
    _totalStopwatch.start();
    _startTotalUiTimer();
    _currentMode = ActiveMode.running;
    _sessionLog.clear(); 
    notifyListeners();
  }

  void _startTotalUiTimer() {
    _totalUiTimer?.cancel();
    _totalUiTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_totalStopwatch.isRunning) {
        notifyListeners();
      } else {
        timer.cancel();
      }
    });
  }

  void _stopRestEngine() {
    _restTimer?.cancel();
    _isResting = false;
    _isManualRest = false;
    _restSecondsRemaining = 0;
  }

  void startSet() {
    _stopRestEngine();
    _totalStopwatch.start();
    _startTotalUiTimer();
    _setStopwatch.reset();
    _setStopwatch.start();
    notifyListeners();
  }

  void stopWorkout() {
    if (_totalStopwatch.isRunning) {
      _totalStopwatch.stop();
      _totalUiTimer?.cancel();
    } else {
      _totalStopwatch.start();
      _startTotalUiTimer();
    }
    notifyListeners();
  }

  void saveSetToNotebook(String exerciseTitle, double weight, int reps, Duration restTime, Duration workDuration, double kcalFromScreen) {
    _setStopwatch.stop();
    _totalStopwatch.stop(); 
    _isResting = true;
    _isManualRest = false;
    _restSecondsRemaining = restTime.inSeconds;

   // Твоя выстраданная логика категорий — НЕ ТРОГАЕМ
    _currentRunningWorkout?.exercises.firstWhere(
      (e) => e.title == exerciseTitle,
      orElse: () => Exercise(
        title: exerciseTitle, category: 'machine', image: '',
        targetMuscles: '', sets: 0, reps: '', restTime: '', description: '', machineCode: '',
      ),
    );

    // Добавляем kcal в создание сета
    final newSet = ExerciseSet(
      weight: weight, 
      reps: reps,
      workDuration: workDuration, 
      restDuration: restTime,
      timestamp: DateTime.now(),
      kcal: kcalFromScreen, // Теперь калории зафиксированы здесь!
    );
    
    if (!_sessionLog.containsKey(exerciseTitle)) _sessionLog[exerciseTitle] = [];
    _sessionLog[exerciseTitle]!.add(newSet);

    _startRestEngine();
    _setStopwatch.reset();
    notifyListeners(); 
  }
  void _startRestEngine() {
    _restTimer?.cancel();
    _restTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isManualRest) {
        if (_restSecondsRemaining > 0) {
          _restSecondsRemaining--;
        } else {
          timer.cancel();
          stopRest();
        }
      } else {
        _restSecondsRemaining++;
      }
      notifyListeners();
    });
  }

  void stopRest() {
    _stopRestEngine();
    if (!_totalStopwatch.isRunning) {
      _totalStopwatch.start();
    }
    _startTotalUiTimer(); 
    notifyListeners();
  }

  void toggleManualRest() {
    _isManualRest = true;
    _startRestEngine();
    notifyListeners();
  }

  void clearWorkout() {
    _totalStopwatch.stop();
    _totalStopwatch.reset();
    _totalUiTimer?.cancel();
    _stopRestEngine();
    _sessionLog.clear();
    _currentRunningWorkout = null;
    _currentMode = ActiveMode.none;
    _isResting = false;
    notifyListeners();
  }

  void addToRunningWorkout(Exercise exercise) {
    if (_currentRunningWorkout != null) { 
      final index = _currentRunningWorkout!.exercises.indexWhere((e) => e.title == exercise.title);
      if (index >= 0) {
        _currentRunningWorkout!.exercises.removeAt(index);
      } else {
        _currentRunningWorkout!.exercises.add(exercise);
      }
      notifyListeners();
    }
  }

  // ... (начало файла до метода finishSession оставляем без изменений) ...

  Future<void> finishSession(String name, BuildContext context) async {
    if (_currentRunningWorkout == null) return;

    // 1. ПЕРВЫМ ДЕЛОМ: Останавливаем все таймеры сразу!
    _totalStopwatch.stop();
    _totalUiTimer?.cancel();
    _stopRestEngine();

    final customLibrary = Provider.of<CustomWorkoutProvider>(context, listen: false);
    final metrics = Provider.of<MetricsProvider>(context, listen: false);

    List<String> exercisesDetails = [];
    double totalKcal = 0.0;

    // Сборка лога (твоя логика без паразитов)
    _sessionLog.forEach((exerciseTitle, sets) {
      if (sets.isNotEmpty) {
        final String titleUpper = exerciseTitle.toUpperCase();
        List<String> currentSetsDetails = [];
        double exerciseKcalTotal = 0;

        bool isCardio = exerciseTitle.toLowerCase().contains('run') || 
                        exerciseTitle.toLowerCase().contains('walk') || 
                        exerciseTitle.toLowerCase().contains('cycl') || 
                        exerciseTitle.toLowerCase().contains('elliptical');

        for (int i = 0; i < sets.length; i++) {
          final s = sets[i];
          double currentKcal = s.kcal; 
          String duration = "${s.workDuration.inMinutes.toString().padLeft(2, '0')}:${(s.workDuration.inSeconds % 60).toString().padLeft(2, '0')}";

          if (isCardio) {
            currentSetsDetails.add("#${i + 1}. ${s.weight.toStringAsFixed(1)} km/h ($duration) 🔥 ${currentKcal.toStringAsFixed(1)} kcal");
          } else {
            currentSetsDetails.add("#${i + 1}. ${s.weight.toStringAsFixed(1)} kg x ${s.reps} ($duration) 🔥 ${currentKcal.toStringAsFixed(1)} kcal");
          }
          exerciseKcalTotal += currentKcal;
        }

        totalKcal += exerciseKcalTotal;
        String prefix = isCardio ? "C=" : "";
        String allSets = currentSetsDetails.join("@"); 
        exercisesDetails.add("$prefix$titleUpper=$allSets=${exerciseKcalTotal.toStringAsFixed(1)}");
      }
    });

    // Определение номера сессии и финализация лога
    String finalName = name.isEmpty ? _currentRunningWorkout!.name : name.toUpperCase();
    int internalSessionNumber = 1;
    
    // Ищем индекс по ID или по Имени (для страховки)
    int index = customLibrary.myCustomList.indexWhere((w) => w.id == _currentRunningWorkout!.id);
    if (index < 0) {
      index = customLibrary.myCustomList.indexWhere((w) => w.name == finalName);
    }
    
    if (index >= 0) {
      internalSessionNumber = customLibrary.myCustomList[index].history.length + 1;
    }

    String timeResult = "${totalTime.inMinutes.toString().padLeft(2, '0')}:${(totalTime.inSeconds % 60).toString().padLeft(2, '0')}";
    String sessionHeader = "SESSION #$internalSessionNumber"; 
    String finalLog = "$sessionHeader\n${exercisesDetails.join("\n")}\n| $timeResult | ${totalKcal.toStringAsFixed(1)} kcal";
    
    try {
      // 1. Ищем папку по строгому совпадению ID
      int index = customLibrary.myCustomList.indexWhere((w) => w.id == _currentRunningWorkout!.id);
      
      // 2. Если по ID не нашли, пробуем по ИМЕНИ (чтобы 5-я не улетела в 4-ю)
      if (index < 0) {
        index = customLibrary.myCustomList.indexWhere((w) => w.name == finalName);
      }

      if (index >= 0 && finalName != "NEW SESSION") {
        // Добавляем в СУЩЕСТВУЮЩУЮ папку, если имена или ID совпали
        customLibrary.addSessionToHistory(customLibrary.myCustomList[index].id, finalLog);
      } else {
        // СОЗДАЕМ НОВУЮ ПАПКУ (для тренировки "5", если её еще нет)
        customLibrary.createNewRoutine(finalName, List<Exercise>.from(_currentRunningWorkout!.exercises));
        
        // Ждем 300мс, чтобы Провайдер успел обновить список в памяти
        await Future.delayed(const Duration(milliseconds: 300));
        
        // Находим свежесозданную папку и пишем историю туда
        final int newIndex = customLibrary.myCustomList.indexWhere((w) => w.name == finalName);
        if (newIndex >= 0) {
          customLibrary.addSessionToHistory(customLibrary.myCustomList[newIndex].id, finalLog);
        }
      }
      
      await customLibrary.saveToDisk();
      await metrics.addBurnedCalories(totalKcal).timeout(const Duration(seconds: 1));
      
    } catch (e) {
      debugPrint("SAVE ERROR: $e");
    } finally {
      clearWorkout();
      notifyListeners();
    }
  }

// ... (остаток файла оставляем как есть) ...

  bool isInEvolution(String title) => _evolutionBasket.any((e) => e.title == title);
  bool isInProtocol(String title) => _protocolBasket.any((e) => e.title == title);
  void setMainTabController(TabController c) => _mainTabController = c;
  void setTabController(TabController c) { _tabController = c; notifyListeners(); }
  void jumpToEquipment() { _mainTabController?.animateTo(0); _tabController?.animateTo(0); notifyListeners(); }
  void jumpToBuild() { _tabController?.animateTo(2); notifyListeners(); }
  void refresh() => notifyListeners();

  @override
  void dispose() { _totalUiTimer?.cancel(); _restTimer?.cancel(); super.dispose(); }

  void toggleEvolution(Exercise exercise) {
    final index = _evolutionBasket.indexWhere((e) => e.title == exercise.title);
    if (index >= 0) {
      _evolutionBasket.removeAt(index);
    } else {
      _evolutionBasket.add(exercise);
    }
    notifyListeners();
  }

  void toggleProtocol(Exercise exercise) {
    final index = _protocolBasket.indexWhere((e) => e.title == exercise.title);
    if (index >= 0) {
      _protocolBasket.removeAt(index);
    } else {
      _protocolBasket.add(exercise);
    }
    notifyListeners();
  }

  void saveAsWorkout(String name, BuildContext context) {
    if (name.isEmpty) name = "MY ROUTINE";
    final String newId = DateTime.now().millisecondsSinceEpoch.toString();
    final library = Provider.of<WorkoutLibraryProvider>(context, listen: false);
    final metrics = Provider.of<MetricsProvider>(context, listen: false);
    double userWeight = metrics.currentWeight > 0 ? metrics.currentWeight : 75.0;

    List<String> notebookPages = [];

    _sessionLog.forEach((exerciseTitle, sets) {
      if (sets.isNotEmpty) {
        final exercise = _currentRunningWorkout?.exercises.firstWhere(
          (e) => e.title == exerciseTitle,
          orElse: () => Exercise(
            title: exerciseTitle, category: 'machine', image: '',
            targetMuscles: '', sets: 0, reps: '', restTime: '', description: '',
            machineCode: '', // ТУТ ТОЖЕ ИСПРАВИЛИ
          ),
        );

        bool isCardio = exercise?.category == 'cardio';
        List<String> currentSetsDetails = [];
        double exerciseKcalTotal = 0;

        for (int i = 0; i < sets.length; i++) {
          final s = sets[i];
          double kcal;
          String duration = "${s.workDuration.inMinutes.toString().padLeft(2, '0')}:${(s.workDuration.inSeconds % 60).toString().padLeft(2, '0')}";
          
          if (isCardio) {
            double speed = s.weight;
            double minutes = s.reps.toDouble();
            double met = (0.1 * speed) + 3.5;
            kcal = (met * 3.5 * userWeight / 200) * (minutes > 0 ? minutes : 0.1);
            currentSetsDetails.add("#${i + 1}. ${speed.toStringAsFixed(1)} km/h - ${s.reps}m ($duration) 🔥 ${kcal.toStringAsFixed(1)} kcal");
          } else {
            kcal = (s.weight * s.reps * 0.012) + 0.5;
            currentSetsDetails.add("#${i + 1}. ${s.weight.toStringAsFixed(1)} kg x ${s.reps} ($duration) 🔥 ${kcal.toStringAsFixed(1)} kcal");
          }
          exerciseKcalTotal += kcal;
        }

        String prefix = isCardio ? "C=" : "";
        String allSets = currentSetsDetails.join("@");
        notebookPages.add("$prefix${exerciseTitle.toUpperCase()}=$allSets=${exerciseKcalTotal.toStringAsFixed(1)}");
      }
    });

    String finalLog = notebookPages.join("\n"); 
    library.createTemplateCustom(newId, name.toUpperCase(), List.from(_evolutionBasket));

    final newRoutine = SavedWorkout(
      id: newId, 
      name: name.toUpperCase(), 
      exercises: List.from(_evolutionBasket),
      sessionResults: finalLog.isNotEmpty ? [finalLog] : [], 
    );

    _savedWorkouts.add(newRoutine);
    _sessionLog.clear(); 
    _evolutionBasket.clear(); 
    _currentMode = ActiveMode.none;
    notifyListeners();
  }
// Вместо void refresh() напиши:
void refreshLaboratory() {
  notifyListeners();
}
}