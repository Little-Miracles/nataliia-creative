import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_body_life/providers/custom_workout_provider.dart';
import 'package:smart_body_life/screens/workout_archive_run_screen.dart'; 
import 'package:smart_body_life/screens/workout_data_models.dart';
import 'package:smart_body_life/widgets/workout_chart.dart';
import 'workout_history_view.dart';

class ActiveWorkoutScreen extends StatefulWidget {
  const ActiveWorkoutScreen({super.key});

  @override
  State<ActiveWorkoutScreen> createState() => _ActiveWorkoutScreenState();
}

class _ActiveWorkoutScreenState extends State<ActiveWorkoutScreen> {
  int? expandedIndex; 

  @override
  Widget build(BuildContext context) {
    final customProvider = context.watch<CustomWorkoutProvider>();
    final myRoutines = customProvider.myCustomList;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        // ИСПРАВЛЕНО: Теперь стрелочка работает более надежно
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFFFFAB00)),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.pop(context);
            } else {
              Navigator.pushReplacementNamed(context, '/hub');
            }
          },
        ),
        title: const Text("PERSONAL ROUTINES", 
          style: TextStyle(
            color: Color(0xFFFFAB00), 
            fontSize: 14, 
            fontWeight: FontWeight.w400, 
            letterSpacing: 2
          )),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("MY ARCHIVE", 
                style: TextStyle(
                  color: Color(0xFFFFAB00), 
                  fontWeight: FontWeight.w400, 
                  letterSpacing: 0, 
                  fontSize: 18 
                )),
              const SizedBox(height: 25),
              Expanded(
                child: myRoutines.isEmpty 
                  ? _buildEmptyHint()
                  : ListView.builder(
                      itemCount: myRoutines.length,
                      itemBuilder: (context, index) {
                        final workout = myRoutines[index];
                        return _buildExpandableLabel(context, index, workout);
                      },
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExpandableLabel(BuildContext context, int index, WorkoutTemplate workout) {
    bool isExpanded = expandedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          expandedIndex = isExpanded ? null : index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: const Color(0xFF111111),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isExpanded ? const Color(0xFFFFAB00) : const Color(0xFFFFAB00).withOpacity(0.2),
            width: isExpanded ? 1.5 : 1,
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            workout.name.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white, 
                              fontWeight: FontWeight.w200, 
                              fontSize: 18, 
                              letterSpacing: 2
                            ),
                          ),
                          if (isExpanded) ...[
                            const SizedBox(width: 12),
                            IconButton(
                              constraints: const BoxConstraints(),
                              padding: EdgeInsets.zero,
                              icon: const Icon(Icons.edit_outlined, color: Colors.white24, size: 16),
                              onPressed: () => _showRenameDialog(context, workout),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              constraints: const BoxConstraints(),
                              padding: EdgeInsets.zero,
                              icon: const Icon(Icons.delete_outline, color: Color(0xFFCF6679), size: 16),
                              onPressed: () => _showDeleteConfirm(context, workout),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "COMPLETED: ${workout.history.length} TIMES", 
                        style: const TextStyle(
                          color: Color(0xFFB0B0B0), 
                          fontSize: 10, 
                          fontWeight: FontWeight.w300, 
                          letterSpacing: 1.5
                        )
                      ),
                    ],
                  ),
                ),
                Icon(isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: const Color(0xFFFFAB00)),
              ],
            ),
            
            if (isExpanded) ...[
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0),
                child: Divider(color: Colors.white10, height: 1),
              ),
              Column(
                children: [
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 2.8,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => WorkoutHistoryView(workout: workout))),
                        child: _buildActionButton("HISTORY", Icons.history),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => WorkoutArchiveRunScreen(workout: workout))),
                        child: _buildActionButton("RE-RUN", Icons.play_arrow),
                      ),
                      GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) => Container(
                              height: MediaQuery.of(context).size.height * 0.7,
                              decoration: const BoxDecoration(
                                color: Color(0xFF0A0A0A),
                                borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                                border: Border(top: BorderSide(color: Color(0xFFFFAB00), width: 1)),
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.symmetric(vertical: 12),
                                    width: 40, height: 4,
                                    decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(2)),
                                  ),
                                  Text(workout.name.toUpperCase(), 
                                    style: const TextStyle(color: Color(0xFFFFAB00), letterSpacing: 2, fontSize: 16)),
                                  const SizedBox(height: 20),
                                  Expanded(
                                    child: WorkoutProgressChart(
                                      // ИСПРАВЛЕНО: Формат данных теперь "лог | дата"
                                      history: workout.history.map((h) => "${h.log.join('\n')} | ${h.date}").toList(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        child: _buildActionButton("STATS", Icons.bar_chart),
                      ),
                      GestureDetector(
                        onTap: () => _showNotesSheet(context, workout),
                        child: _buildActionButton("MY NOTES", Icons.edit_note),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(String label, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFFFAB00).withOpacity(0.4), width: 0.8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: const Color(0xFFFFAB00), size: 16),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  void _showNotesSheet(BuildContext context, WorkoutTemplate workout) {
    // 1. ТЕПЕРЬ ПОДТЯГИВАЕМ СУЩЕСТВУЮЩИЙ ТЕКСТ (вместо "...")
    TextEditingController notesController = TextEditingController(text: workout.notes ?? "");

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.4,
          decoration: const BoxDecoration(
            color: Color(0xFF111111),
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
            border: Border(top: BorderSide(color: Color(0xFFFFAB00), width: 1)),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("NOTES: ${workout.name}", 
                    style: const TextStyle(color: Color(0xFFFFAB00), fontWeight: FontWeight.bold, fontSize: 14)),
                  IconButton(
                    icon: const Icon(Icons.check_circle_outline, color: Color(0xFFFFAB00)),
                    onPressed: () {
                      // 2. ВОТ ОН, НАШ ПРОВОД! Вызываем сохранение в провайдере
                      context.read<CustomWorkoutProvider>().updateWorkoutNotes(
                        workout.id, 
                        notesController.text
                      );
                      Navigator.pop(context); // Закрываем шторку
                    },
                  ),
                ],
              ),
              const Divider(color: Colors.white10),
              Expanded(
                child: TextField(
                  controller: notesController,
                  maxLines: null,
                  style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w300),
                  decoration: const InputDecoration(
                    hintText: "Write something...",
                    hintStyle: TextStyle(color: Colors.white10),
                    border: InputBorder.none,
                  ),
                  autofocus: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildEmptyHint() {
    return const Center(
      child: Text("FOLDER IS EMPTY\nCREATE AND SAVE A ROUTINE FIRST", 
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white10, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }

  void _showRenameDialog(BuildContext context, WorkoutTemplate workout) {
    TextEditingController renameController = TextEditingController(text: workout.name);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF111111),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: const BorderSide(color: Color(0xFFFFAB00), width: 1),
        ),
        title: const Text("RENAME ROUTINE", 
          style: TextStyle(color: Color(0xFFFFAB00), fontSize: 14, fontWeight: FontWeight.bold)),
        content: TextField(
          controller: renameController,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white10)),
            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFFFFAB00))),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("CANCEL", style: TextStyle(color: Colors.white24)),
          ),
          TextButton(
            onPressed: () {
              if (renameController.text.isNotEmpty) {
                context.read<CustomWorkoutProvider>().renameWorkout(workout.id, renameController.text);
                Navigator.pop(context);
              }
            },
            child: const Text("SAVE", style: TextStyle(color: Color(0xFFFFAB00))),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirm(BuildContext context, WorkoutTemplate workout) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF111111),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text("DELETE?", style: TextStyle(color: Colors.redAccent, fontSize: 16)),
        content: Text("Are you sure you want to delete '${workout.name}'?", 
          style: const TextStyle(color: Colors.white70, fontSize: 12)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), 
            child: const Text("NO", style: TextStyle(color: Colors.white))
          ),
          TextButton(
            onPressed: () {
              context.read<CustomWorkoutProvider>().deleteWorkout(workout.id);
              Navigator.pop(context);
            }, 
            child: const Text("YES, DELETE", style: TextStyle(color: Colors.redAccent))
          ),
        ],
      ),
    );
  } 
}