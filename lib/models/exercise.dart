class Exercise {
  final String id;
  final String name;
  final String equipmentCategory;

  final String primaryMetric;
  final String secondaryMetric;
  final double caloriesPerUnit;

  // 👇 ДОБАВИТЬ
  final String? difficultyLevel;
  final String? goal;
  final String? muscles;
  final String? technique;
  final String? setup;
  final String? safety;
  // 👇 ВОТ ОНО - УНИВЕРСАЛЬНОЕ РЕШЕНИЕ
  // Список ID других упражнений, которые спрятаны "внутри" этого
  final List<String>? alternativeIds; 

  // Поля для работы Плеера (динамические данные)
  int sets;
  String reps;
  String restTime;
  double? actualWeight;
  int? actualReps;
  int? actualRestTime;
  bool isCompleted;
  int elapsedSeconds;
  String? image; // Путь к картинке

  // --- ВОТ ЭТО ОЧЕНЬ ВАЖНО ДОБАВИТЬ ДЛЯ РАБОТЫ ЛОГИКИ СТАТУСОВ (M018) ---
  Map<String, dynamic>? params; // <-- ДОБАВИТЬ ЭТУ СТРОЧКУ

  Exercise({
    required this.id,
    required this.name,
    required this.equipmentCategory,
    required this.primaryMetric,
    required this.secondaryMetric,
    required this.caloriesPerUnit,

    // 👇 ДОБАВИТЬ
    this.difficultyLevel,
    this.goal,
    this.muscles,
    this.technique,
    this.setup,
    this.safety,
    this.alternativeIds, // Сюда мы запишем ['BB_Chest', 'DB_Chest']
    this.sets = 0,
    this.reps = '0',
    this.restTime = '0s',
    this.isCompleted = false,
    this.elapsedSeconds = 0,
    this.image,
    this.params, 
  });

  // 👇 Оживляем геттеры, чтобы Плеер не получал "null"
  String get title => name;
  String get machineCode => id;
  String? get imagePath => image;
  // Тот самый "мостик" для Таймера, который уберет красную ошибку:
  String get kcal => caloriesPerUnit.toString(); // <-- ДОБАВИТЬ ЭТО

  // Если в коде используется description, а у нас это goal:
  String? get description => goal; // <-- МОЖНО ДОБАВИТЬ ДЛЯ ПОДСТРАХОВКИ

}