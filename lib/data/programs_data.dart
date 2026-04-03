import 'training_data.dart';
import '../screens/workout_data_models.dart';

class WeightLossPrograms {
  // Получаем доступ ко всем упражнениям из вашей базы
  static final List<Exercise> _all = TrainingData.getAllExercises();

  // Вспомогательный метод для поиска упражнения по коду
  static Exercise _get(String code) {
    return _all.firstWhere((e) => e.machineCode == code);
  }

  // 1. ПРОГРАММА: ЖИРОСЖИГАЮЩИЙ ИНТЕНСИВ (FAT BURN INTENSIVE)
  static final WorkoutPlan fatBurnIntensive = WorkoutPlan(
    title: "FAT BURN: INTENSIVE",
    description: "Высокая интенсивность для максимального сжигания калорий.",
    duration: "50 min", frequency: "3x week", level: "Beginner",
    warmUp: [_get('M001')], // Дорожка
    mainWorkout: [
      _get('M007'), // Жим ногами
      _get('M026'), // Гантели (тут наш калькулятор!)
      _get('M004'), // Тяга блока
      _get('M010'), // Жим от груди
    ],
    coolDown: [_get('M021')], // Растяжка
  );

  // 2. ПРОГРАММА: КРУГОВАЯ ТРЕНИРОВКА (CIRCUIT SHRED)
  static final WorkoutPlan circuitShred = WorkoutPlan(
    title: "CIRCUIT SHRED",
    description: "Упражнения одно за другим для выносливости.",
    duration: "45 min", frequency: "2-3x week", level: "Intermediate",
    warmUp: [_get('M001')], 
    mainWorkout: [
      _get('M026'), // Гантели
      _get('M018'), // Тренажер (выбор)
      _get('M027'), // Штанга (тут наш новый калькулятор!)
      _get('M008'), // Разгибание ног
    ],
    coolDown: [_get('M021')],
  );

  // 3. ПРОГРАММА: СИЛУЭТ И КАРДИО (SLIM & TONE)
  static final WorkoutPlan slimTone = WorkoutPlan(
    title: "SLIM & TONE",
    description: "Акцент на нижнюю часть тела и пресс.",
    duration: "60 min", frequency: "3x week", level: "Intermediate",
    warmUp: [_get('M001')],
    mainWorkout: [
      _get('M007'), // Жим ногами
      _get('M026'), // Гантели
      _get('M005'), // Гиперэкстензия
      _get('M011'), // Баттерфляй
    ],
    coolDown: [_get('M021')],
  );

  // 4. ПРОГРАММА: УТРЕННЯЯ СУШКА (MORNING METABOLISM)
  static final WorkoutPlan morningMetabolism = WorkoutPlan(
    title: "MORNING METABOLISM",
    description: "Быстрая тренировка для запуска метаболизма.",
    duration: "30 min", frequency: "Daily", level: "Beginner",
    warmUp: [_get('M001')],
    mainWorkout: [
      _get('M026'), // Гантели
      _get('M004'), // Тяга
      _get('M010'), // Жим
    ],
    coolDown: [_get('M021')],
  );

  // Список всех программ для отображения на экране
  static List<WorkoutPlan> get all => [
    fatBurnIntensive,
    circuitShred,
    slimTone,
    morningMetabolism
  ];
}