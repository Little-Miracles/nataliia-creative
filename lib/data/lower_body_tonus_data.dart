import '../screens/workout_data_models.dart';
import 'exercise_library.dart';

final lowerBodyTonusPlan = WorkoutPlan(
  title: 'Lower Body Lift',
  duration: '4-6 Weeks',
  frequency: 'Daily / 3-4 days',
  level: 'BEG',
  description: 'Focused on skin elasticity and lymphatic drainage in the lower body. Improves blood circulation and helps reduce swelling/puffiness in the legs.',
  //'Программа для тонуса кожи нижней части тела. Улучшаем кровоток и боремся с отечностью.',
  warmUp: [exM003], // Эллипс
  mainWorkout: [
    exM009, // Степпер (Лимфодренаж)
    exM010, // Hip Adductor/Abductor (Тонус бедер)
    exM028, // Stability Ball
  ],
  coolDown: [exM033],
);