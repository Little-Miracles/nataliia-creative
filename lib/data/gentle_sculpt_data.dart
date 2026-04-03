import '../screens/workout_data_models.dart';
import 'exercise_library.dart'; // Импортируем нашу "Лабораторию"

// -----------------------------------------------------------------
// WEIGHT LOSS PROGRAMS LIBRARY
// -----------------------------------------------------------------
class WeightLossLibrary {
  static List<WorkoutPlan> getPlans() {
    return [
      gentleSculptPlan,
    ];
  }
}

// =================================================================
// 1. ПРОГРАММА: GENTLE SCULPT 60+
// =================================================================
final gentleSculptPlan = WorkoutPlan(
  title: 'Gentle Sculpt 60+',
  duration: '10 Weeks',
  frequency: '3 Days / Week',
  level: 'BEG',
  description: 'A gentle full-body sculpting routine designed for individuals aged 60 and above. This program focuses on light resistance training to enhance muscle tone, improve mobility, and promote overall well-being.',
  warmUp: [ 
    exM007, // Treadmill
  ],
  mainWorkout: [
    exM018, // Seated Chest Press (Теперь с вариантами 1-2-3!)
    exM011, // Leg Press
    exM020, // Lat Pulldown
    exM017, // Seated Row
    exM016, // Shoulder Press
    exM003, // Leg Extension
  ],
  coolDown: [
    exM033, // Elasticity Stretch
  ],
);
// =================================================================