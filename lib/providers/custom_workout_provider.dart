import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_body_life/screens/workout_data_models.dart';

class CustomWorkoutProvider with ChangeNotifier {
  final List<WorkoutTemplate> _myCustomList = [];

  CustomWorkoutProvider() {
    loadFromDisk();
  }

  List<WorkoutTemplate> get myCustomList => _myCustomList;

  void createNewRoutine(String name, List<Exercise> exercises) {
    final String uniqueId = DateTime.now().millisecondsSinceEpoch.toString();
    final newRoutine = WorkoutTemplate(
      id: uniqueId,
      name: name.toUpperCase(),
      exercises: List.from(exercises),
      history: [], 
    );
    _myCustomList.add(newRoutine);
    saveToDisk();
    notifyListeners();
  }

  // Обнови только этот метод в custom_workout_provider.dart
  void addSessionToHistory(String workoutId, String results) {
    int index = _myCustomList.indexWhere((w) => w.id == workoutId);
    if (index >= 0) {
      // Создаем сессию
      final newSession = WorkoutSession(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        date: DateTime.now(),
        log: [results], // Тот самый текст: "20kg x 10 🔥..."
        exercises: List.from(_myCustomList[index].exercises), 
      );

      // Добавляем в основной список истории (откуда берет ГРАФИК)
      _myCustomList[index].history.add(newSession);
      
      // Добавляем в результаты (откуда берет список HISTORY)
      _myCustomList[index].sessionResults ??= [];
      _myCustomList[index].sessionResults!.add(results);
      
      saveToDisk();
      notifyListeners();
    }
  }

  Future<void> saveToDisk() async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> dataToSave = _myCustomList.map((workout) {
      return {
        'id': workout.id,
        'name': workout.name,
        'sessionResults': workout.sessionResults,
        'exercises': workout.exercises.map((e) => {
          'id': e.id, 'title': e.title, 'category': e.category,
          'machineCode': e.machineCode, 'targetMuscles': e.targetMuscles,
          'sets': e.sets, 'reps': e.reps, 'restTime': e.restTime, 'image': e.image,
        }).toList(),
        // СОХРАНЯЕМ ДАТУ ВМЕСТЕ С ЛОГОМ
        'history_data': workout.history.map((s) => {
          'date': s.date.toIso8601String(),
          'log': s.log,
        }).toList(), 
      };
    }).toList();
    await prefs.setString('workout_safe_archive_v5', json.encode(dataToSave)); // Меняем версию на v5
  }

  Future<void> loadFromDisk() async {
    final prefs = await SharedPreferences.getInstance();
    final String? savedData = prefs.getString('workout_safe_archive_v5');
    
    if (savedData != null) {
      try {
        final List<dynamic> decodedData = json.decode(savedData);
        _myCustomList.clear();
        
        for (var item in decodedData) {
          // ... (загрузка упражнений остается такой же)
          List<Exercise> loadedExercises = (item['exercises'] as List? ?? []).map((e) => Exercise(
            id: e['id']?.toString(), title: e['title'] ?? 'Unknown',
            category: e['category'] ?? 'Archive', machineCode: e['machineCode'] ?? 'N/A',
            targetMuscles: e['targetMuscles'] ?? 'Multiple', sets: e['sets'] ?? 1,
            reps: e['reps']?.toString() ?? '10', restTime: e['restTime'] ?? '60s',
            image: e['image'] ?? '',
          )).toList();

          final workout = WorkoutTemplate(id: item['id'], name: item['name'], exercises: loadedExercises);
          workout.sessionResults = item['sessionResults'] != null ? List<String>.from(item['sessionResults']) : [];

          if (item['history_data'] != null) {
            workout.history = (item['history_data'] as List).map((h) {
              return WorkoutSession(
                id: DateTime.now().toString(), 
                date: DateTime.parse(h['date']), // ВОССТАНАВЛИВАЕМ РЕАЛЬНУЮ ДАТУ
                log: List<String>.from(h['log']), 
                exercises: [], 
              );
            }).toList();
          }
          _myCustomList.add(workout);
        }
        notifyListeners();
      } catch (e) {
        debugPrint("Load error: $e");
      }
    }
  }
  // Остальные методы (удаление, переименование)
  void deleteWorkout(String id) { _myCustomList.removeWhere((w) => w.id == id); saveToDisk(); notifyListeners(); }
  void renameWorkout(String id, String newName) {
    int index = _myCustomList.indexWhere((w) => w.id == id);
    if (index >= 0) { _myCustomList[index].name = newName; saveToDisk(); notifyListeners(); }
  }
}