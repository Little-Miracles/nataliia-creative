import 'package:flutter/material.dart';
import '../screens/workout_data_models.dart';

class WorkoutProvider with ChangeNotifier {
  // 1. КОРЗИНА УПРАЖНЕНИЙ
  final List<Exercise> _selectedExercises = [];
  List<Exercise> get selectedExercises => _selectedExercises;

  // 2. ВЫБОР ОБОРУДОВАНИЯ (из твоего второго файла)
  List<String> _selectedEquipment = [];
  List<String> get selectedEquipment => _selectedEquipment;

  // 3. ДАННЫЕ КАЛЬКУЛЯТОРА И ТЕЛА (из твоего первого файла)
  double _currentWeight = 0; // Текущий вес
  double _goalWeight = 0;    // Целевой вес
  int _goalCalories = 0;     // Цель по калориям

  double get currentWeight => _currentWeight;
  double get goalWeight => _goalWeight;
  int get goalCalories => _goalCalories;

  // --- ЛОГИКА РАСЧЕТА КАЛОРИЙ ---
  int get totalBurnedCalories {
    double total = 0.0;
    for (var exercise in _selectedExercises) {
      // Так как в модели kcal — это String?, мы используем tryParse
      // exercise.kcal ?? '0' — если калорий нет, берем строку '0'
      double kcalValue = double.tryParse(exercise.kcal.toString()) ?? 0.0;
      total += kcalValue;
    }
    return total.toInt(); // Превращаем в целое число для баннера
  }

  // --- МЕТОДЫ УПРАВЛЕНИЯ КОРЗИНОЙ ---

  // Добавить или удалить упражнение (для кнопки Плюс)
  void toggleExercise(Exercise exercise) {
    final index = _selectedExercises.indexWhere((e) => e.title == exercise.title);
    if (index >= 0) {
      _selectedExercises.removeAt(index);
    } else {
      _selectedExercises.add(exercise);
    }
    notifyListeners(); 
  }

  // Удалить конкретное упражнение (например, крестиком в корзине)
  void removeExercise(Exercise exercise) {
    _selectedExercises.removeWhere((e) => e.title == exercise.title);
    notifyListeners();
  }

  // Проверка: добавлено ли упражнение (для цвета кнопки)
  bool isAdded(String title) {
    return _selectedExercises.any((e) => e.title == title);
  }

  // --- МЕТОДЫ УПРАВЛЕНИЯ ОБОРУДОВАНИЕМ ---

  void setEquipment(List<String> equipment) {
    _selectedEquipment = equipment;
    notifyListeners(); 
  }

  // --- МЕТОДЫ УПРАВЛЕНИЯ ДАННЫМИ ТЕЛА ---

  // Обновление данных после калькулятора (чтобы баннер обновился)
  void updateBodyData({required double current, required double goal, required int kcal}) {
    _currentWeight = current;
    _goalWeight = goal;
    _goalCalories = kcal;
    notifyListeners(); 
  }

  // ПОЛНАЯ ОЧИСТКА
  void clearPlan() {
    _selectedExercises.clear();
    _selectedEquipment.clear();
    notifyListeners(); 
  }
}