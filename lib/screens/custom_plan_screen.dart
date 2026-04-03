import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/workout_provider.dart'; // Путь к нашему новому провайдеру

class CustomPlanScreen extends StatefulWidget {
  const CustomPlanScreen({super.key});

  @override
  State<CustomPlanScreen> createState() => _CustomPlanScreenState();
}

class _CustomPlanScreenState extends State<CustomPlanScreen> {
  @override
  Widget build(BuildContext context) {
    // Подключаемся к WorkoutProvider, чтобы видеть все выбранные тренажеры
    final workoutProvider = Provider.of<WorkoutProvider>(context);
    final selectedExercises = workoutProvider.selectedExercises;

    return Column(
      children: [
        // --- ЗАГОЛОВОК С КОЛИЧЕСТВОМ И КНОПКОЙ ОЧИСТКИ ---
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Your Plan: ${selectedExercises.length} Exercises',
                style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)
              ),
              // НОВАЯ КНОПКА-ПЛЮСИК (вставляем сюда)
    IconButton(
      icon: const Icon(Icons.add_circle, color: Color(0xFFFFAB00), size: 30),
      onPressed: () {
        // Эта команда переключит вкладку на GYM (оборудование)
        DefaultTabController.of(context).animateTo(0); 
      },
    ),
              if (selectedExercises.isNotEmpty)
                ElevatedButton(
                  onPressed: () => workoutProvider.clearPlan(), // Вызываем метод очистки
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFAB00),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  child: const Text('Clear Plan'),
                ),
            ],
          ),
        ),
        
        // --- СПИСОК ВЫБРАННЫХ УПРАЖНЕНИЙ (СТИЛЬ 60+) ---
        Expanded(
          child: selectedExercises.isEmpty
              ? const Center(
                  child: Text(
                    'Tap "+" on equipment to build your plan.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: selectedExercises.length,
                  itemBuilder: (context, index) {
                    final exercise = selectedExercises[index];
                    return _buildWorkoutCard(exercise, workoutProvider);
                  },
                ),
        ),

        // --- КНОПКА ЗАПУСКА ТРЕНИРОВКИ ---
        if (selectedExercises.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  // Логика начала тренировки
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFAB00),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: const Text(
                  'START WORKOUT',
                  style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
      ],
    );
  }

  // Вспомогательный виджет для карточки упражнения (как на Фото 60+)
  Widget _buildWorkoutCard(exercise, workoutProvider) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFF1E2D24), // Твой темно-зеленый цвет
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  exercise.name,
                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              // Кнопка удаления (или можно сделать INFO)
              IconButton(
                icon: const Icon(Icons.remove_circle_outline, color: Colors.redAccent),
                onPressed: () => workoutProvider.toggleExercise(exercise),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Ряд с параметрами (Sets, Reps, Weight, Rest)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildInputColumn("Sets", "0"),
              _buildInputColumn("Reps", "0 reps"),
              _buildInputColumn("Weight", "0 kg"),
              _buildInputColumn("Rest", "0 s"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInputColumn(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.white54, fontSize: 12)),
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.black26,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(value, style: const TextStyle(color: Color(0xFFFFAB00), fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}