// lib/screens/exercise_list_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// Используем теперь только одну модель, чтобы не было путаницы
import 'package:smart_body_life/screens/workout_data_models.dart'; 
import 'package:smart_body_life/data/training_data.dart';
import 'package:smart_body_life/providers/workout_provider.dart';

class ExerciseDetailListScreen extends StatefulWidget {
  final String category;
  final VoidCallback onBack;

  const ExerciseDetailListScreen({
    super.key, 
    required this.category, 
    required this.onBack,
  });

  @override
  State<ExerciseDetailListScreen> createState() => _ExerciseDetailListScreenState();
}

class _ExerciseDetailListScreenState extends State<ExerciseDetailListScreen> {
  // Теперь храним machineCode (напр. 'M001')
  final Set<String> _selectedExerciseIds = {};

  void _showExerciseDetails(BuildContext context, Exercise exercise) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF111111),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6, // Шторка стала чуть меньше, так как нет картинки
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return Padding(
              padding: const EdgeInsets.all(25.0),
              child: ListView(
                controller: scrollController,
                children: [
                  Center(
                    child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(10))),
                  ),
                  const SizedBox(height: 25),
                  Text(exercise.title, style: const TextStyle(color: Color(0xFFFF9800), fontSize: 24, fontWeight: FontWeight.bold)),
                  const Divider(color: Colors.white10, height: 40),
                  
                  // ОСТАВЛЯЕМ ТОЛЬКО ТЕКСТОВЫЕ ЛЕЙБЛЫ (КАРТИНКА ТЕПЕРЬ ТОЛЬКО СНАРУЖИ)
                  _buildDetailSection("🎯 Goal", exercise.description ?? ''),
                  _buildDetailSection("🔧 Setup", exercise.setup ?? ''),
                  _buildDetailSection("⚙️ Technique", exercise.instructions ?? ''),
                  _buildDetailSection("⚠️ Safety", exercise.safety ?? ''),
                  const SizedBox(height: 40),
                ],
              ),
            );
          },
        );
      },
    );
  }
  Widget _buildDetailSection(String title, String content) {
    if (content.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title.toUpperCase(), style: const TextStyle(color: Color(0xFFFF9800), fontSize: 10, fontWeight: FontWeight.w900)),
          const SizedBox(height: 8),
          Text(content, style: const TextStyle(color: Colors.white70, fontSize: 15, height: 1.5)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Получаем список упражнений (теперь это объекты Exercise из workout_data_models)
    final List<Exercise> exercises = TrainingData.getExercisesByCategory(widget.category);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.category.toUpperCase(),
          style: const TextStyle(color: Color(0xFFFF9800), fontWeight: FontWeight.w900, letterSpacing: 1.5),
        ),
      actions: [
  IconButton(
    icon: const Icon(Icons.menu_book_rounded, color: Color(0xFFFF9800)),
    onPressed: () {
      final List<Exercise> exercises = TrainingData.getExercisesByCategory(widget.category);
      showModalBottomSheet(
        context: context,
        backgroundColor: const Color(0xFF111111),
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
        builder: (context) => DraggableScrollableSheet(
          initialChildSize: 0.8,
          expand: false,
          builder: (_, controller) => ListView.builder(
            controller: controller,
            padding: const EdgeInsets.all(25),
            itemCount: exercises.length,
            itemBuilder: (context, index) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(exercises[index].title, style: const TextStyle(color: Color(0xFFFF9800), fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(height: 8),
                // Вставляем второй раз, чтобы "Книжка" тоже показывала всё
_buildDetailSection("🎯 Goal", exercises[index].description ?? ''),
_buildDetailSection("🔧 Setup", exercises[index].setup ?? ''),
_buildDetailSection("⚙️ Technique", exercises[index].instructions ?? ''),
_buildDetailSection("⚠️ Safety", exercises[index].safety ?? ''),
                const Divider(color: Colors.white10, height: 30),
              ],
            ),
          ),
        ),
      );
    },
  ),
],
      ),
      body: exercises.isEmpty
          ? const Center(child: Text("No exercises found", style: TextStyle(color: Colors.white)))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: exercises.length,
              itemBuilder: (context, index) {
                final exercise = exercises[index];
                final isSelected = _selectedExerciseIds.contains(exercise.machineCode);

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF111111),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? const Color(0xFFFF9800) : Colors.white.withOpacity(0.05),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () => _showExerciseDetails(context, exercise),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          // Картинка (путь из TrainingData)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: SizedBox(
                              width: 80, height: 80,
                              child: Image.asset(
                                exercise.image ?? '',
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) => 
                                    const Icon(Icons.fitness_center, color: Colors.white24),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  exercise.title, // Было name, стало title
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(Icons.flash_on, size: 14, color: Colors.grey),
                                    const SizedBox(width: 4),
                                    Text(
                                      exercise.machineCode, // Код машины (напр. M001)
                                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                                    ),
                                    const SizedBox(width: 12),
                                    const Icon(Icons.local_fire_department, size: 14, color: Color(0xFFFF9800)),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${exercise.kcal ?? '0'} kcal', // Используем kcal из модели
                                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          // КНОПКА ДОБАВЛЕНИЯ
                          IconButton(
                            onPressed: () {
                              // Кладем копию упражнения в корзину
                              Provider.of<WorkoutProvider>(context, listen: false)
                                  .toggleExercise(exercise);

                              setState(() {
                                if (_selectedExerciseIds.contains(exercise.machineCode)) {
                                  _selectedExerciseIds.remove(exercise.machineCode);
                                } else {
                                  _selectedExerciseIds.add(exercise.machineCode);
                                }
                              });
                            },
                            icon: Icon(
                              isSelected ? Icons.check_circle : Icons.add_circle,
                              color: isSelected ? const Color(0xFF1A1A1A) : const Color(0xFFFF9800),
                              size: 34,
                            ),
                          ), 
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}