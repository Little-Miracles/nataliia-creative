import '../screens/workout_data_models.dart';
import 'exercise_library.dart';

final lowerHypertrophyPlan = WorkoutPlan(
  title: 'Hypertrophy: Lower Body',
  duration: '10 Weeks',
  frequency: '2-3 Days / Week',
  level: 'INT',
  description: 'Serious leg day focus. Concentrates on building quadriceps, hamstrings, and calves through heavy resistance and progressive overload.',
  warmUp: [ exM014, exM009 ], // Велосипед + Степпер
  mainWorkout: [
    exM019, // Leg Press
    exM001, // Leg Extension
    exM011, // Seated Leg Curl
    exM022, // Calf Raise
  ],
  coolDown: [ exM033 ],
); // Stretching