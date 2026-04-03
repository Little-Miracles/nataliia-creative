import '../screens/workout_data_models.dart';
import 'exercise_library.dart';

final upperHypertrophyPlan = WorkoutPlan(
  title: 'Hypertrophy: Upper Body',
  duration: '10 Weeks',
  frequency: '3-4 Days / Week',
  level: 'INT',
  description: 'Designed for maximum upper body volume. High-intensity sets targeting chest, back, and shoulders to create a powerful V-taper physique.',
  warmUp: [ exM016, exM031 ], // Гребля + плечи
  mainWorkout: [
    exM021, // Incline Press
    exM020, // Lat Pulldown
    exM024, // Independent Shoulder Press
    exM025, // Lever Chest Press
    exM005, // Pec Deck
  ],
  coolDown: [ exM032 ],
); // Stretching