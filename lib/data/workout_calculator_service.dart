// lib/data/workout_calculator_service.dart

enum ExerciseCategory { machine, freeWeight, cardio }

class WorkoutCalculatorService {
  
  static double calculateBurnedCalories({
    required ExerciseCategory category,
    required double value, 
    required int reps,     
    required Duration time, 
  }) {
    double mins = time.inSeconds / 60;
    if (mins < 0.1) mins = 0.1;

    // Убрали default, чтобы не было желтого предупреждения
    switch (category) {
      case ExerciseCategory.cardio:
        return 8.0 * mins * (1 + (value / 12));

      case ExerciseCategory.freeWeight:
        return (value * reps * 0.04) + (mins * 2.5);

      case ExerciseCategory.machine:
        return (mins * 7.0) + (value * 0.01 * reps);
    }
  }

  static ExerciseCategory mapStringToCategory(String? categoryName) {
    if (categoryName == null) return ExerciseCategory.machine;
    
    // Приводим к нижнему регистру и убираем пробелы для надежности
    final cleanName = categoryName.toLowerCase().trim();
    
    if (cleanName == 'cardio') {
      return ExerciseCategory.cardio;
    } else if (cleanName == 'free' || cleanName == 'freeweights') {
      return ExerciseCategory.freeWeight;
    } else {
      return ExerciseCategory.machine;
    }
  }
}