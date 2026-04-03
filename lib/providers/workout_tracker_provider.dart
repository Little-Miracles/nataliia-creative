import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart'; 
import 'package:smart_body_life/data/training_data.dart';
import 'package:smart_body_life/screens/workout_data_models.dart'; 
import 'package:smart_body_life/providers/metrics_provider.dart';

class WorkoutTrackerProvider with ChangeNotifier {
  void updateMetricsLink(MetricsProvider metrics) {}
  
  WorkoutPlan? _currentPlan;
  int _sessionTotalSeconds = 0;
  Timer? _sessionTimer;
  bool _isSessionActive = false;

  Exercise? _activeExercise;
  Timer? _exerciseTimer;
  
  Timer? _restTimer;
  int _restRemainingSeconds = 0;
  bool _isResting = false;

  bool _isManualRest = false;
  int _manualRestSeconds = 0;

  double _sessionTonnage = 0.0; // Общий вес за всю тренировку
  double get sessionTonnage => _sessionTonnage; // Чтобы другие файлы видели это число

  bool get isSessionActive => _isSessionActive;
  bool get isResting => _isResting;
  int get restRemaining => _restRemainingSeconds;
  int get sessionTotalSeconds => _sessionTotalSeconds;
  Exercise? get activeExercise => _activeExercise;
  bool get isWorkoutActive => _isSessionActive;
  bool get isManualRest => _isManualRest; 
  int get manualRestSeconds => _manualRestSeconds; 
// ИСПРАВЛЕНИЕ ОШИБКИ: Форматированное время сессии
  String get elapsedTime => Duration(seconds: _sessionTotalSeconds).toString().split('.').first.padLeft(8, "0");
  WorkoutPlan? get currentPlan => _currentPlan; // Открываем доступ к плану
  // Счётчик для панели 0/9
  int get completedExercisesCount {
    if (_currentPlan == null) return 0;
    return _currentPlan!.allExercises.where((ex) => ex.isCompleted).length;
  }
  void refreshUI() => notifyListeners();

  // ВСТАВЬТЕ ЭТОТ КУСОК:
  double calculateCalories() {
    if (_currentPlan == null) return 0.0;
    double totalCalories = 0.0;
    
    // Получаем список всех упражнений из базы один раз (для скорости)
    final allBaseExercises = TrainingData.getAllExercises();

    for (var exercise in _currentPlan!.allExercises) {
      // Очищаем код (превращаем "res_gym/M018.png" в "M018")
      final String cleanCode = exercise.machineCode
          .split('/').last 
          .split('.').first;

      // Ищем упражнение по очищенному коду
      final baseInfo = allBaseExercises.firstWhere(
        (e) => e.machineCode.contains(cleanCode) || e.id == cleanCode,
        orElse: () => allBaseExercises.first,
      );

      double exerciseMinutes = exercise.elapsedSeconds / 60.0;
      
      // Безопасно переводим kcal из строки в число
      double kcalPerMinute = double.tryParse(baseInfo.kcal ?? "0") ?? 0.0;
      
      totalCalories += exerciseMinutes * kcalPerMinute;
    }
    return totalCalories;
  }
  
  void startSession(WorkoutPlan plan) {
    if (_isSessionActive) return;
    _currentPlan = plan;
    _isSessionActive = true;
    _sessionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _sessionTotalSeconds++;
      notifyListeners();
    });
    notifyListeners();
  }

  void startExercise(Exercise exercise) {
    _exerciseTimer?.cancel();
    _restTimer?.cancel();
    _isManualRest = false;

    if (_activeExercise != null && _activeExercise != exercise) {
      stopExercise(_activeExercise!);
    }
    _activeExercise = exercise;
    _isResting = false;
    
    _exerciseTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      exercise.elapsedSeconds++;
      notifyListeners();
    });
    notifyListeners();
  }

  void stopExercise(Exercise exercise) {
    if (_activeExercise == exercise) {
      _exerciseTimer?.cancel();
      _activeExercise = null;
      exercise.isCompleted = true;
      _isResting = false;
      _isManualRest = false;
      _restTimer?.cancel();
      notifyListeners();
    }
  }

  void toggleManualRest() {
    _isManualRest = !_isManualRest;
    if (_isManualRest) {
      _exerciseTimer?.cancel();
      _restTimer?.cancel();
      _isResting = true;
      _manualRestSeconds = 0;
      _restTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        _manualRestSeconds++;
        notifyListeners();
      });
    } else {
      _restTimer?.cancel();
      _isResting = false;
      if (_activeExercise != null) startExercise(_activeExercise!);
    }
    notifyListeners();
  }

  void triggerRest(Exercise exercise) {
    if (_activeExercise != exercise) return;
    _exerciseTimer?.cancel(); 
    _isResting = true;
    _isManualRest = false;
    
    int duration = exercise.actualRestTime ?? 45; 
    _restRemainingSeconds = duration;
    notifyListeners();

    _restTimer?.cancel();
    _restTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_restRemainingSeconds > 0) {
        _restRemainingSeconds--;
        notifyListeners();
      } else {
        timer.cancel();
        _isResting = false;
        HapticFeedback.heavyImpact(); 
        startExercise(exercise); 
      }
    });
  }
  
  void skipRest() {
    _restTimer?.cancel();
    _isResting = false;
    _isManualRest = false;
    _restRemainingSeconds = 0;
    if (_activeExercise != null) startExercise(_activeExercise!);
    notifyListeners();
  }

  void endSession() {
    _sessionTimer?.cancel();
    _exerciseTimer?.cancel();
    _restTimer?.cancel();
    _isSessionActive = false;
    _activeExercise = null;
    _isManualRest = false;
    notifyListeners();
  }

  // --- ВОТ ЭТОТ МЕТОД БЫЛ ПОТЕРЯН! ---
  void resetDataAndExit(WorkoutPlan plan) {
    endSession();
    _sessionTotalSeconds = 0;
    for (var ex in plan.allExercises) {
      ex.actualWeight = null;
      ex.actualReps = null;
      ex.actualRestTime = null;
      ex.isCompleted = false;
      ex.elapsedSeconds = 0;
    }
    notifyListeners();
  }
  // МЕТОД ДЛЯ БЛОКНОТА: Записывает подход и обновляет все графики
  void logSet({
    required Exercise exercise, 
    required double weight, 
    int reps = 0, 
    required MetricsProvider metrics
  }) {
    // 1. Считаем Тоннаж (Общий вес для "толстеющего" графика)
    double setVolume = weight * reps;
    _sessionTonnage += setVolume;

    // 2. Считаем Калории (Силовая добавка к основному расчету)
    // Каждые 100 кг поднятого веса дают примерно 5-7 доп. калорий
    double strengthKcal = setVolume * 0.05; 

    // 3. ОТПРАВЛЯЕМ ДАННЫЕ НА ВКЛАДКИ HOME И BODY
    // Обновляем общий счетчик сожженного за сегодня
    metrics.updateBurned(metrics.burnedToday + strengthKcal);
    
    // 4. Даем вибро-отклик (подтверждение записи)
    HapticFeedback.mediumImpact(); 

    notifyListeners(); // Обновляем баннер и все экраны
  }
  @override
  void dispose() {
    _sessionTimer?.cancel();
    _exerciseTimer?.cancel();
    _restTimer?.cancel();
    super.dispose();
  }

  void startRestTimer(int restSeconds, {required Null Function() onTimerEnd}) {}
}