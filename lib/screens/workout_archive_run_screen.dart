import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:smart_body_life/providers/active_session_provider.dart';
import 'package:smart_body_life/screens/workout_data_models.dart';
import 'package:smart_body_life/widgets/notebook_work_card.dart';

class WorkoutArchiveRunScreen extends StatefulWidget {
  final WorkoutTemplate workout;
  const WorkoutArchiveRunScreen({super.key, required this.workout});

  @override
  State<WorkoutArchiveRunScreen> createState() => _WorkoutArchiveRunScreenState();
}

class _WorkoutArchiveRunScreenState extends State<WorkoutArchiveRunScreen> {
  Timer? _refreshTimer;
  final Color kAntiqueGold = const Color(0xFFC5A059);
  final Color kActiveBlue = const Color(0xFF2196F3);

  @override
  void initState() {
    super.initState();
    _refreshTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ActiveSessionProvider>(
      builder: (context, session, child) {
        // Гарантируем, что упражнения берутся из шаблона, даже если сессия в процессе
        final List<Exercise> exercises = session.isWorkoutActive 
            ? (session.currentRunningWorkout?.exercises ?? widget.workout.exercises.cast<Exercise>().toList())
            : widget.workout.exercises.cast<Exercise>().toList();

        return Scaffold(
          backgroundColor: Colors.black,
          appBar: _buildAppBar(session),
          body: Column(
            children: [
              _buildTopControls(session, exercises),
              _buildDateAndInfoRow(session),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildExerciseList(session, exercises),
                      const _SessionHistoryList(), // ДОБАВЬ ВОТ ЭТО! 
                      const SizedBox(height: 50),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(ActiveSessionProvider session) {
    return AppBar(
      backgroundColor: Colors.black,
      elevation: 0,
      toolbarHeight: 90,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.close, color: Colors.white, size: 22),
        onPressed: () => Navigator.pop(context),
      ),
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(widget.workout.name.toUpperCase(), 
            style: TextStyle(color: kAntiqueGold.withOpacity(0.8), fontSize: 12, letterSpacing: 2.5)),
          const SizedBox(height: 8),
          Text(_formatDuration(session.totalTime), 
            style: const TextStyle(color: Colors.white, fontSize: 34, fontFamily: 'monospace', fontWeight: FontWeight.w200)),
        ],
      ),
    );
  }

  void _showFinishDialog(BuildContext context, ActiveSessionProvider session) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF111111),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0xFFC5A059), width: 0.5),
        ),
        title: const Text("FINISH & SAVE?", style: TextStyle(color: Color(0xFFC5A059))),
        content: const Text("Progress will be added to history.", style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("CANCEL", style: TextStyle(color: Colors.white24))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFC5A059)),
            onPressed: () async {
              await session.finishSession(widget.workout.name, context);
              if (mounted) {
                Navigator.of(context).pop(); 
                Navigator.of(context).pop(); 
              }
            },
            child: const Text("SAVE", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildTopControls(ActiveSessionProvider session, List<Exercise> exercises) {
    final bool isWorkoutActive = session.isWorkoutActive;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (!isWorkoutActive) {
                  session.startWorkoutFromTemplate(widget.workout.name, exercises, existingId: widget.workout.id);
                } else {
                  session.stopWorkout();
                }
              },
              child: Container(
                height: 44,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: kAntiqueGold, width: 1.5),
                ),
                alignment: Alignment.center,
                child: Text(!isWorkoutActive ? "START" : (session.isTimerRunning ? "PAUSE" : "RESUME"),
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
          if (isWorkoutActive) ...[
            const SizedBox(width: 10),
            Expanded(
              child: GestureDetector(
                onTap: () => _showFinishDialog(context, session),
                child: Container(
                  height: 44,
                  decoration: BoxDecoration(color: kAntiqueGold, borderRadius: BorderRadius.circular(10)),
                  alignment: Alignment.center,
                  child: const Text("SAVE", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ]
        ],
      ),
    );
  }

  Widget _buildExerciseList(ActiveSessionProvider session, List<Exercise> exercises) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      itemCount: exercises.length,
      itemBuilder: (context, index) => NotebookWorkCard(exercise: exercises[index]),
    );
  }

  Widget _buildDateAndInfoRow(ActiveSessionProvider session) {
    if (!session.isResting) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(25, 20, 25, 10),
        child: Row(
          children: [
            Text("${DateTime.now().day}.${DateTime.now().month}.${DateTime.now().year}", style: const TextStyle(color: Colors.white70, fontSize: 13)),
            const Spacer(),
            Icon(Icons.bolt, color: kAntiqueGold.withOpacity(0.8), size: 16),
            const Text(" SESSION DATA", style: TextStyle(color: Colors.white60, fontSize: 12)),
          ],
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(icon: const Icon(Icons.stop_circle_outlined, color: Colors.redAccent, size: 28), onPressed: () => session.stopRest()),
          Column(
            children: [
              Text(session.isManualRest ? "MANUAL REST" : "REST TIME", style: TextStyle(color: kAntiqueGold, fontSize: 9)),
              Text(_formatRestTime(session.restSecondsRemaining), style: TextStyle(color: kAntiqueGold, fontSize: 22, fontFamily: 'monospace')),
            ],
          ),
          IconButton(icon: Icon(Icons.touch_app_outlined, color: session.isManualRest ? Colors.orange : Colors.white38, size: 26), onPressed: () => session.toggleManualRest()),
        ],
      ),
    );
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return "${twoDigits(d.inMinutes)}:${twoDigits(d.inSeconds.remainder(60))}";
  }

  String _formatRestTime(int totalSeconds) {
    int mins = totalSeconds ~/ 60;
    int secs = totalSeconds % 60;
    return "${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}";
  }
}

  class _SessionHistoryList extends StatelessWidget {
  const _SessionHistoryList();

  @override
  Widget build(BuildContext context) {
    return Consumer<ActiveSessionProvider>(
      builder: (context, session, child) {
        if (session.sessionLog.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 30, 25, 10),
              child: Text(
                "SESSION LOG",
                style: TextStyle(
                  color: const Color(0xFFFFAB00).withOpacity(0.7),
                  fontSize: 12,
                  fontWeight: FontWeight.w300,
                  letterSpacing: 2.0,
                ),
              ),
            ),
            ...session.sessionLog.entries.map((entry) {
              final exerciseTitle = entry.key;
              final String titleLower = exerciseTitle.toLowerCase();
              
              bool isCardio = titleLower.contains('run') || 
                              titleLower.contains('walk') || 
                              titleLower.contains('cycl') || 
                              titleLower.contains('elliptical');

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.02),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.white.withOpacity(0.05)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exerciseTitle.toUpperCase(),
                      style: TextStyle(
                          color: isCardio ? Colors.greenAccent : const Color(0xFFC0C0C0).withOpacity(0.9),
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 1.2),
                    ),
                    const SizedBox(height: 12),
                    ...entry.value.asMap().entries.map((setEntry) {
                      final setData = setEntry.value;
                      final String kcalValue = setData.kcal.toStringAsFixed(1);
                      final String duration = "${setData.workDuration.inMinutes.toString().padLeft(2, '0')}:${(setData.workDuration.inSeconds % 60).toString().padLeft(2, '0')}";

                      return Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: const BoxDecoration(
                          border: Border(bottom: BorderSide(color: Colors.white10, width: 0.5)),
                        ),
                        child: Row(
                          children: [
                            Text(isCardio ? "SESSION" : "SET ${setEntry.key + 1}",
                                style: TextStyle(
                                    color: isCardio ? Colors.greenAccent : const Color(0xFFC0C0C0), 
                                    fontSize: 15, 
                                    fontWeight: FontWeight.w300)),
                            const Spacer(),
                            if (isCardio) 
                               _metric(duration, "min")
                            else ...[
                               _metric("${setData.weight}", "kg"),
                               const SizedBox(width: 8),
                               _metric("${setData.reps}", "reps"),
                            ],
                            const SizedBox(width: 20),
                            _metric(kcalValue, "kcal"),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              );
            }),
          ],
        );
      },
    );
  }

  Widget _metric(String value, String label) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(value,
            style: const TextStyle(
                color: Color(0xFFC0C0C0),
                fontSize: 18,
                fontWeight: FontWeight.w300,
                fontFamily: 'monospace')),
        const SizedBox(width: 3),
        Text(label, style: const TextStyle(color: Colors.white38, fontSize: 10)),
      ],
    );
  }
}
