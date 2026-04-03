// lib/models/exercise.dart

class Exercise {
  // Уникальный ID (для внутреннего использования)
  final String id;
  // Название упражнения (например, 'Жим ногами', 'Беговая дорожка')
  final String name; 
  // Категория инструмента (например, 'MACHINES', 'CARDIO_MACHINES')
  final String equipmentCategory; 

  // --- МЕТРИКИ (Как измеряем) ---

  // Основной показатель: 'REPS' (Повторения) или 'TIME' (Время)
  final String primaryMetric; 
  // Дополнительный показатель: 'WEIGHT' (Вес) или 'DISTANCE' (Дистанция)
  final String secondaryMetric; 

  // Калории за единицу измерения (потребуется для автоматического расчета)
  final double caloriesPerUnit; 

  Exercise({
    required this.id,
    required this.name,
    required this.equipmentCategory,
    required this.primaryMetric,
    required this.secondaryMetric,
    required this.caloriesPerUnit,
  });
}