import '../screens/workout_data_models.dart';
import 'exercise_library.dart';

final foundationStrengthPlan = WorkoutPlan(
  title: 'Foundation: Strength',
  duration: '8 Weeks',
  frequency: '3 Days / Week',
  level: 'BEG',
  description: 'The perfect starting point for muscle growth. Focuses on major muscle groups using primary machines to build a solid strength base and master correct form.',
  warmUp: [ exM007 ], // Дорожка
  mainWorkout: [
    exM019, // Leg Press
    exM018, // Chest Press
    exM017, // Seated Row
    exM023, // Overhead Press
  ],
  coolDown: [ exM032 ],
); // Stretching