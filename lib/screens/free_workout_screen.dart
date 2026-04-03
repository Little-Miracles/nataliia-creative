import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/workout_provider.dart';
import '../screens/active_workout_screen.dart';
import '../screens/workout_data_models.dart';

class FreeWorkoutScreen extends StatelessWidget {
  const FreeWorkoutScreen({super.key});

  final Color kBgColor = const Color(0xFF000000);
  final Color kAccentColor = const Color(0xFFFFAB00);

  @override
  Widget build(BuildContext context) {
    final workoutProvider = Provider.of<WorkoutProvider>(context);
    final selectedExercises = workoutProvider.selectedExercises;

    return Scaffold(
      backgroundColor: kBgColor,
      body: Column(
        children: [
          // ШАПКА: BUILD YOUR PLAN + ПЛЮСИК
          Padding(
            padding: const EdgeInsets.only(top: 60, left: 20, right: 20, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "BUILD YOUR PLAN (${selectedExercises.length})", 
                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900)
                ),
                // ТОТ САМЫЙ ПЛЮСИК (переход к оборудованию)
                IconButton(
                  icon: Icon(Icons.add_circle, color: kAccentColor, size: 32),
                  onPressed: () {
                    // Возвращаемся на первую вкладку (Equipment)
                    DefaultTabController.of(context).animateTo(0);
                  },
                ),
              ],
            ),
          ),
          
          Divider(color: Colors.white.withAlpha(13)), // Новый синтаксис Alpha

          // СПИСОК В КОРЗИНЕ
          Expanded(
            child: selectedExercises.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: selectedExercises.length,
                    itemBuilder: (context, index) => _buildBasketCard(workoutProvider, selectedExercises[index]),
                  ),
          ),

          // КНОПКА START (Черный текст на оранжевом)
          if (selectedExercises.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
              child: ElevatedButton(
                onPressed: () => Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => const ActiveWorkoutScreen())
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: kAccentColor,
                  minimumSize: const Size(double.infinity, 60),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                child: const Text("START TRAINING", 
                  style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w900)),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBasketCard(WorkoutProvider provider, Exercise exercise) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF111111),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withAlpha(13)),
      ),
      child: Row(
        children: [
          // Картинка
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: exercise.image != null 
                ? Image.asset(exercise.image!, width: 45, height: 45, fit: BoxFit.contain)
                : const Icon(Icons.fitness_center, color: Colors.white24),
          ),
          const SizedBox(width: 15),
          // Название
          Expanded(
            child: Text(exercise.title, 
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
          // КРЕСТИК (Удаление)
          IconButton(
            icon: const Icon(Icons.close, color: Colors.redAccent, size: 20),
            onPressed: () => provider.removeExercise(exercise),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Text("Your basket is empty", style: TextStyle(color: Colors.white.withAlpha(50))),
    );
  }
}