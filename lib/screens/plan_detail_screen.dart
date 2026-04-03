// lib/screens/plan_detail_screen.dart

import 'package:flutter/material.dart';      
import 'workout_data_models.dart';         
// 1. ИСПРАВЛЯЕМ ИМПОРТ (указываем на новый файл)
import 'workout_detail_screen.dart';       

class PlanDetailScreen extends StatelessWidget {
  final WorkoutPlan plan; 

  const PlanDetailScreen({super.key, required this.plan});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(plan.title, style: const TextStyle(color: Color(0xFFFF9800), fontWeight: FontWeight.bold)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(plan.description, style: const TextStyle(color: Colors.white70, fontSize: 16)),
            
            const SizedBox(height: 25), // Добавил немного отступа
            const Text('EXERCISES IN THIS PLAN:', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),

            // Вывод списка упражнений
            ...plan.mainWorkout.map((exercise) => Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF1E2D24),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      exercise.image ?? '', 
                      width: 50, 
                      height: 50, 
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.fitness_center, color: Colors.white24),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Text(exercise.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                  const Icon(Icons.chevron_right, color: Colors.white24),
                ],
              ),
            )),

            const SizedBox(height: 40),

            ElevatedButton(
              onPressed: () {
                // 2. ИСПРАВЛЯЕМ ПЕРЕХОД (теперь вызываем WorkoutDetailScreen)
                Navigator.push(
                  context, 
                  MaterialPageRoute(
                    builder: (context) => WorkoutDetailScreen(plan: plan)
                  )
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF9800),
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              child: const Text('START THIS PLAN', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}