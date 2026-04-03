import '../screens/workout_data_models.dart';
import 'exercise_library.dart';

final slimLegsPlan = WorkoutPlan(
  title: 'Slim Legs & Calves',
  duration: '8 Weeks',
  frequency: '3 Days / Week',
  level: 'BEG',
  description: 'A program for slender, athletic legs. Strengthens muscle fibers without adding excessive volume, focusing on calf definition and overall leg symmetry.',
  //'Программа для стройных ног. Укрепляем мышцы без лишнего объема, работаем над рельефом голени.',
  warmUp: [exM014], // Велосипед (разминка)
  mainWorkout: [
    exM001, // Leg Extension
    exM011, // Seated Leg Curl
    exM022, // Calf Raise (Голень)
  ],
  coolDown: [exM033],
);