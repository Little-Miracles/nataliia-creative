import 'training_data.dart';
import '../screens/workout_data_models.dart';

class FatBurnCollection {
  // Доступ к общей базе упражнений
  static final List<Exercise> _all = TrainingData.getAllExercises();

  static Exercise _get(String code) {
    return _all.firstWhere((e) => e.machineCode == code);
  }

  // 1. ИНТЕНСИВ
  static final WorkoutPlan fatBurnIntensive = WorkoutPlan(
    title: "FAT BURN: INTENSIVE",
    level: "INTERMEDIATE",
    frequency: "3 DAYS / WEEK",
    duration: "50 min",
    description: "Максимальный огонь! Высокая интенсивность для быстрого сжигания калорий и тонуса мышц.",
    warmUp: [_get('M001')], 
    mainWorkout: [_get('M007'), _get('M026'), _get('M004'), _get('M010')],
    coolDown: [_get('M021')],
  );

  // 2. КРУГОВАЯ
  static final WorkoutPlan circuitShred = WorkoutPlan(
    title: "CIRCUIT SHRED",
    level: "ADVANCED",
    frequency: "3 DAYS / WEEK",
    duration: "45 min",
    description: "Круговая тренировка без пауз. Идеально для тех, кто хочет стальной рельеф и выносливость.",
    warmUp: [_get('M001')],
    mainWorkout: [_get('M026'), _get('M018'), _get('M027'), _get('M008')],
    coolDown: [_get('M021')],
  );

  // 3. СИЛУЭТ
  static final WorkoutPlan slimTone = WorkoutPlan(
    title: "SLIM & TONE",
    level: "BEGINNER",
    frequency: "3 DAYS / WEEK",
    duration: "60 min",
    description: "Акцент на стройные ноги и подтянутый пресс. Мягкое похудение и формирование красивого силуэта.",
    warmUp: [_get('M001')],
    mainWorkout: [_get('M007'), _get('M026'), _get('M005'), _get('M011')],
    coolDown: [_get('M021')],
  );

  // 4. МЕТАБОЛИЗМ
  static final WorkoutPlan morningMetabolism = WorkoutPlan(
    title: "MORNING METABOLISM",
    level: "BEGINNER",
    frequency: "5 DAYS / WEEK",
    duration: "30 min",
    description: "Короткий утренний драйв! Запускает метаболизм на весь день. Минимум времени — максимум пользы.",
    warmUp: [_get('M001')],
    mainWorkout: [_get('M026'), _get('M004'), _get('M010')],
    coolDown: [_get('M021')],
  );

  // Общий список для вывода на экран
  static List<WorkoutPlan> get all => [
    fatBurnIntensive,
    circuitShred,
    slimTone,
    morningMetabolism
  ];
}