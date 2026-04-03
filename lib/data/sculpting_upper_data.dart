import '../screens/workout_data_models.dart'; // ../ означает "выйти на уровень выше"
import 'training_data.dart';                // Без точек, так как они в одной папке providers
// Идем в папку screens за библиотекой

// =================================================================
// ПРОГРАММА: SCULPTING UPPER BODY (Отдельный лист)
// =================================================================

final sculptingUpperPlan = WorkoutPlan(
  title: 'Sculpting Upper Body',
  duration: '8 Weeks',
  frequency: '3 Days / Week',
  level: 'BEG',
  description: 'TRAINER\'S SECRETS:\n'
      '1. SEAT HEIGHT: Upper chest level.\n'
      '2. 30° INCLINE for volume.\n'
      '3. WATER SCOOP in Cable Fly.\n'
      '4. POSTURE: Blades glued to seat.\n'
      '5. FINISH: Bar hang.',
      
  warmUp: [
    // Берем чистые упражнения из базы
    TrainingData.getAllExercises().firstWhere((e) => e.machineCode == 'M007'), // Treadmill
    TrainingData.getAllExercises().firstWhere((e) => e.machineCode == 'M031'), // Shoulder Prep
  ],

  mainWorkout: [
    // Остальные берем чистыми из базы
    TrainingData.getAllExercises().firstWhere((e) => e.machineCode == 'M025'), // Lever Press
    TrainingData.getAllExercises().firstWhere((e) => e.machineCode == 'M005'), // Pec Deck
    TrainingData.getAllExercises().firstWhere((e) => e.machineCode == 'M017'), // Seated Row
  // ТВОЯ ТРОЙКА ДЛЯ СБИВКИ
    TrainingData.getAllExercises().firstWhere((e) => e.machineCode == 'M018'), // Machine Bicep Curl
  ],
  
  coolDown: [
    TrainingData.getAllExercises().firstWhere((e) => e.machineCode == 'M028'), // Decompression
  ],
);