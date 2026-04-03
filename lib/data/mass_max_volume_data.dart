import '../screens/workout_data_models.dart';
import 'exercise_library.dart';

final maxMassVolumePlan = WorkoutPlan(
  title: 'Mass: Maximum Volume',
  duration: '12 Weeks',
  frequency: '4-5 Days / Week',
  level: 'ADV',
  description: 'Advanced mass-building protocol. Utilizing heavy compounds and high-volume sets for experienced athletes looking to push past plateaus.',
  warmUp: [ exM007 ],
  mainWorkout: [
    exM019, // Heavy Leg Press
    exM027, // Barbell Work
    exM026, // Dumbbells
    exM015, // Glute Thrust
    exM008, // Torso Rotation (Core Power)
  ],
  coolDown: [ exM032 ],
); // Stretching