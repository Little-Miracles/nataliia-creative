// lib/models/workout_plan.dart
import 'exercise.dart'; // Предполагаем, что этот файл уже создан

class WorkoutPlan {
  // Название плана (например, 'Верх тела', 'Ноги + Плечи')
  final String title; 
  // Список упражнений, включенных в этот план
  final List<Exercise> exercises; 
  // Общее описание или цель
  final String? description; 

  WorkoutPlan({
    required this.title,
    required this.exercises,
    this.description,
  });
}
  