import '../screens/workout_data_models.dart';
import 'exercise_library.dart';

final tonedArmsPlan = WorkoutPlan(
  title: 'Toned Arms & Shoulders',
  duration: '6 Weeks',
  frequency: '2-3 Days / Week',
  level: 'BEG',
  description: 'Focus on toning the arms and shoulders. Eliminate flabbiness and enhance muscle definition.',
  warmUp: [exM031], // Разминка плеч
  mainWorkout: [
    exM013, // Triceps Extension (Подтяжка задней части рук)
    exM005, // Pec Deck Fly (Грудь и руки)
    exM006, // Cable Work (Бицепс/Трицепс)
  ],
  coolDown: [exM032],
);