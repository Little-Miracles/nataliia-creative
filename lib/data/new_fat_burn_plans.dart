import 'training_data.dart';
import '../screens/workout_data_models.dart';

// Назвали по-другому, чтобы не было конфликтов
class FatBurnCollection {
  static final List<Exercise> _all = TrainingData.getAllExercises();

  static Exercise _get(String code) {
    return _all.firstWhere((e) => e.machineCode == code);
  }

  // 1. FAT BURN: INTENSIVE
  static final WorkoutPlan fatBurnIntensive = WorkoutPlan(
    title: "FAT BURN: INTENSIVE",
    description: "Высокая интенсивность для максимального сжигания калорий.",
    duration: "50 min", frequency: "3x week", level: "Beginner",
    warmUp: [_get('M001')],
    mainWorkout: [_get('M007'), _get('M026'), _get('M004'), _get('M010')],
    coolDown: [_get('M021')],
  );

  // 2. CIRCUIT SHRED
  static final WorkoutPlan circuitShred = WorkoutPlan(
    title: "CIRCUIT SHRED",
    description: "Упражнения одно за другим для выносливости.",
    duration: "45 min", frequency: "3x week", level: "Intermediate",
    warmUp: [_get('M001')], 
    mainWorkout: [_get('M026'), _get('M018'), _get('M027'), _get('M008')],
    coolDown: [_get('M021')],
  );

  // 3. SLIM & TONE
  static final WorkoutPlan slimTone = WorkoutPlan(
    title: "SLIM & TONE",
    description: "Акцент на нижнюю часть тела и пресс.",
    duration: "60 min", frequency: "3x week", level: "Intermediate",
    warmUp: [_get('M001')],
    mainWorkout: [_get('M007'), _get('M026'), _get('M005'), _get('M011')],
    coolDown: [_get('M021')],
  );

  // 4. MORNING METABOLISM
  static final WorkoutPlan morningMetabolism = WorkoutPlan(
    title: "MORNING METABOLISM",
    description: "Быстрая тренировка для запуска метаболизма.",
    duration: "30 min", frequency: "Daily", level: "Beginner",
    warmUp: [_get('M001')],
    mainWorkout: [_get('M026'), _get('M004'), _get('M010')],
    coolDown: [_get('M021')],
  );

  // Список только этих четырех программ
  static List<WorkoutPlan> get list => [
    fatBurnIntensive,
    circuitShred,
    slimTone,
    morningMetabolism
  ];
}