import '../screens/workout_data_models.dart';
import 'exercise_library.dart'; // Ваша "Лаборатория" со всеми тюнингованными машинами

// =================================================================
// ПРОГРАММА 1: SYMMETRY & SILHOUETTE (Тонкая талия)
// =================================================================
final waistSculptPlan = WorkoutPlan(
  title: 'Symmetry & Silhouette',
  duration: '8 Weeks',
  frequency: '3 Days / Week',
  level: 'BEG',
  description: 'A specialized program designed to shape a slim waist and flat stomach. Focuses on precise movement vectors and deep core muscle activation without adding unnecessary bulk.',
  warmUp: [ 
    exM007, // Дорожка
    exM031, // Разминка плеч
  ],
  mainWorkout: [
    exM008, // Torso Rotation (Тренажер / Гантели / Трос)
    exM002, // Abdominal Crunches
    exM017, // Lat Pulldown (Широкая спина = визуально узкая талия)
    exM028, // Stability Ball
  ],
  coolDown: [
    exM032, // Растяжка спины
  ],
);

// =================================================================
// ПРОГРАММА 2: GRACEFUL FOUNDATION (Ноги и Попа)
// =================================================================
final lowerBodyGracePlan = WorkoutPlan(
  title: 'Graceful Foundation',
  duration: '8 Weeks',
  frequency: '3 Days / Week',
  level: 'INT',
  description: 'Sculpting elegant leg lines and lifting the glutes. This routine emphasizes the posterior chain and muscle elasticity using controlled machine resistance.',
  warmUp: [ 
    exM009, // Степпер
  ],
  mainWorkout: [
    exM019, // Leg Press (Высокая постановка стоп)
    exM015, // Radial Glute Thrust
    exM010, // Adductor/Abductor
    exM011, // Seated Leg Curl
  ],
  coolDown: [
    exM033, // Растяжка бедер
  ],
);