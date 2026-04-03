import 'package:flutter/material.dart';
// Используем твою основную рабочуя модель
import 'package:smart_body_life/screens/workout_data_models.dart';
import 'package:smart_body_life/screens/live_action_timer_screen.dart';

class OutdoorLabList extends StatelessWidget {
  final String category;

  const OutdoorLabList({super.key, required this.category});

  // --- БИБЛИОТЕКА УПРАЖНЕНИЙ (M035 - M041) ---
 List<Exercise> _getExerciseData() {
    if (category == "WATER") {
      return [
        Exercise(
          title: 'POOL SWIMMING',
          category: 'WATER',
          machineCode: 'M039',
          targetMuscles: 'Full Body', // ТЕПЕРЬ ЭТОТ АРГУМЕНТ НА МЕСТЕ
          kcal: '350',
          sets: 1,
          reps: '30 min',
          restTime: '0s',
          image: 'res_gym/M039.png',
          description: '1. Focus on long, fluid strokes. 2. Keep your body horizontal.',
          isCompleted: false,
          params: {'level': 'MED'},
        ),
        Exercise(
          title: 'OPEN WATER',
          category: 'WATER',
          machineCode: 'M040',
          targetMuscles: 'Full Body / Endurance',
          kcal: '400',
          sets: 1,
          reps: '20 min',
          restTime: '0s',
          image: 'res_gym/M040.png',
          description: '1. Practice sighting to stay on course. 2. Adapt to waves.',
          isCompleted: false,
          params: {'level': 'ADV'},
        ),
        Exercise(
          title: 'AQUA AEROBICS',
          category: 'WATER',
          machineCode: 'M041',
          targetMuscles: 'Core / Cardio',
          kcal: '300',
          sets: 1,
          reps: '45 min',
          restTime: '0s',
          image: 'res_gym/M041.png',
          description: '1. Use water resistance. 2. Keep core tight.',
          isCompleted: false,
          params: {'level': 'BEG'},
        ),
      ];
    }

    if (category == "OUTDOOR") {
      return [
        Exercise(
          title: 'RUNNING',
          category: 'OUTDOOR',
          machineCode: 'M035',
          targetMuscles: 'Cardio / Legs',
          kcal: '450',
          sets: 1,
          reps: '5 km',
          restTime: '0s',
          image: 'res_gym/M035.png',
          description: '1. Land softly on midfoot. 2. Keep elbows at 90 degrees.',
          isCompleted: false,
          params: {'level': 'BEG'},
        ),
        Exercise(
          title: 'CYCLING',
          category: 'OUTDOOR',
          machineCode: 'M036',
          targetMuscles: 'Quads / Glutes',
          kcal: '380',
          sets: 1,
          reps: '10 km',
          restTime: '0s',
          image: 'res_gym/M036.png',
          description: '1. Keep high cadence. 2. Relax shoulders.',
          isCompleted: false,
          params: {'level': 'MED'},
        ),
        Exercise(
          title: 'FAST WALKING',
          category: 'OUTDOOR',
          machineCode: 'M037',
          targetMuscles: 'Lower Body',
          kcal: '250',
          sets: 1,
          reps: '30 min',
          restTime: '0s',
          image: 'res_gym/M037.png',
          description: '1. Roll from heel to toe. 2. Pump arms vigorously.',
          isCompleted: false,
          params: {'level': 'BEG'},
        ),
        Exercise(
          title: 'OUTDOOR TRAINING',
          category: 'OUTDOOR',
          machineCode: 'M038',
          targetMuscles: 'Full Body',
          kcal: '320',
          sets: 3,
          reps: '12-15',
          restTime: '45s',
          image: 'res_gym/M038.png',
          description: '1. Use park benches. 2. Focus on range of motion.',
          isCompleted: false,
          params: {'level': 'MED'},
        ),
      ];
    }
    return [];
  }
  @override
  Widget build(BuildContext context) {
    const Color gemGold = Color(0xFFFFAB00);
    final List<Exercise> exercises = _getExerciseData();

    return Scaffold(
      backgroundColor: const Color(0xFF05100A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(category, style: const TextStyle(color: gemGold, fontWeight: FontWeight.w900, letterSpacing: 2)),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: exercises.length,
        itemBuilder: (context, index) {
          final ex = exercises[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            height: 110,
            decoration: BoxDecoration(
              color: const Color(0xFF111111),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: Colors.white.withOpacity(0.05)),
            ),
            child: Row(
              children: [
                // 1. КАРТИНКА
                Container(
                  width: 100,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(25), bottomLeft: Radius.circular(25)),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(25), bottomLeft: Radius.circular(25)),
                    child: Image.asset(
                      ex.image ?? '',
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.fitness_center, color: Colors.black26),
                    ),
                  ),
                ),
                // 2. ТЕКСТ
                // 2. ТЕКСТ (Центр)
Expanded(
  child: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // НАЗВАНИЕ (Золотое, как на скрине F553)
        Text(
          ex.title,
          style: const TextStyle(color: Color(0xFFFFAB00), fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 4),
        // УРОВЕНЬ (Как на скрине CF70)
        Text(
          "Level: ${ex.params?['level'] ?? 'BEG'}", 
          style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 12),
        ),
      ],
    ),
  ),
),
                // 3. КНОПКИ
                IconButton(
                  icon: const Icon(Icons.info_outline, color: gemGold),
                  onPressed: () => _showInfoSheet(context, ex),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle, color: gemGold, size: 32),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LiveActionTimerScreen(exercise: ex.title)),
                    );
                  },
                ),
                const SizedBox(width: 8),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showInfoSheet(BuildContext context, Exercise ex) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF111111),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        expand: false,
        builder: (_, controller) => ListView(
          controller: controller,
          padding: const EdgeInsets.all(25),
          children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(10)))),
            const SizedBox(height: 25),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(ex.image ?? '', height: 200, fit: BoxFit.contain),
            ),
            const SizedBox(height: 25),
            Text(ex.title, style: const TextStyle(color: Color(0xFFFFAB00), fontSize: 24, fontWeight: FontWeight.bold)),
            Text(ex.machineCode, style: const TextStyle(color: Colors.white30, fontSize: 14)),
            const Divider(color: Colors.white10, height: 40),
            const Text("TECHNIQUE", style: TextStyle(color: Color(0xFFFFAB00), fontSize: 10, fontWeight: FontWeight.w900)),
            const SizedBox(height: 8),
            Text(ex.description ?? '', style: const TextStyle(color: Colors.white70, fontSize: 15, height: 1.5)),
          ],
        ),
      ),
    );
  }
}