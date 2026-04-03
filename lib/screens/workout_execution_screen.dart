import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:smart_body_life/providers/active_session_provider.dart';
import 'package:smart_body_life/screens/active_workout_screen.dart';
import 'package:smart_body_life/screens/workout_data_models.dart';
import 'package:smart_body_life/widgets/notebook_work_card.dart';

class WorkoutExecutionScreen extends StatefulWidget {
  final SavedWorkout? workout;
  const WorkoutExecutionScreen({super.key, this.workout});

  @override
  State<WorkoutExecutionScreen> createState() => _WorkoutExecutionScreenState();
}

class _WorkoutExecutionScreenState extends State<WorkoutExecutionScreen> {
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
        final List<Exercise> exercises = session.isWorkoutActive 
            ? (session.currentRunningWorkout?.exercises ?? [])
            : (widget.workout?.exercises ?? []);

        return Scaffold(
          backgroundColor: Colors.black,
          appBar: _buildAppBar(session),
          body: Column(
            children: [
              _buildTopControls(session, exercises),
              _buildDateAndInfoRow(session),
              Expanded(
                child: exercises.isEmpty
                    ? _buildOnboarding(session)
                    : SingleChildScrollView(
                        child: Column(
                          children: [
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: const EdgeInsets.symmetric(horizontal: 15),
                              itemCount: exercises.length,
                              itemBuilder: (context, index) =>
                                  NotebookWorkCard(exercise: exercises[index]),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: IconButton(
                                icon: const Icon(Icons.add_circle_outline, color: Color(0xFFC5A059), size: 35),
                                onPressed: () {
                                  // Твоя логика добавления тренажера
                                },
                              ),
                            ),
                            const _SessionHistoryList(),
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

  Widget _buildOnboarding(ActiveSessionProvider session) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
      alignment: Alignment.topCenter,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _onboardingStep("1. Tap ", "START SESSION", session.isWorkoutActive, true),
          const SizedBox(height: 16),
          _onboardingStep("2. Work on ", "YOUR GOALS", exercisesNotEmpty(session), session.isWorkoutActive),
        ],
      ),
    );
  }

  bool exercisesNotEmpty(ActiveSessionProvider session) => 
      session.currentRunningWorkout?.exercises.isNotEmpty ?? false;
    Widget _onboardingStep(String prefix, String buttonName, bool isDone, bool isActive) {
    return Opacity(
      opacity: isActive ? 1.0 : 0.3,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(isDone ? Icons.check_circle : Icons.circle_outlined, color: isDone ? kAntiqueGold : Colors.white38, size: 22),
          const SizedBox(width: 15),
          RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.5),
              children: [
                TextSpan(text: prefix, style: const TextStyle(color: Colors.white70)),
                TextSpan(text: buttonName, style: TextStyle(color: kAntiqueGold, fontWeight: FontWeight.w900)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(ActiveSessionProvider session) {
    return AppBar(
      backgroundColor: Colors.black,
      elevation: 0,
      toolbarHeight: 90,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
       onPressed: () => _showFinishDialog(context), 
      ),
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("WORKOUT SESSION", style: TextStyle(color: kAntiqueGold.withOpacity(0.8), fontSize: 14, letterSpacing: 2.5)),
          const SizedBox(height: 8),
          Text(_formatDuration(session.totalTime), style: TextStyle(color: kAntiqueGold, fontSize: 34, fontFamily: 'monospace', fontWeight: FontWeight.w200)),
        ],
      ),
      actions: [
        if (exercisesNotEmpty(session))
          TextButton(
            onPressed: () => _showFinishDialog(context),
            child: const Text("FINISH", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 16)),
          ),
      ],
    );
  }

  Widget _buildTopControls(ActiveSessionProvider session, List<Exercise> exercises) {
    final bool isTimerRunning = session.isTimerRunning;
    final bool hasStarted = session.totalTime.inSeconds > 0;
    final bool isPaused = hasStarted && !isTimerRunning;
    Color statusColor = isPaused ? Colors.redAccent : (hasStarted ? kActiveBlue : kAntiqueGold);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: GestureDetector(
        onTap: () {
          if (!session.isWorkoutActive) {
            session.startWorkoutFromTemplate(widget.workout?.name ?? "NEW SESSION", exercises);
          } else {
            session.stopWorkout();
          }
        },
        child: Container(
          height: 48,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: statusColor, width: 1.5),
          ),
          alignment: Alignment.center,
          child: Text(
            !hasStarted ? "START SESSION" : (isTimerRunning ? "STOP TIMER" : "RESUME"),
            style: TextStyle(color: isPaused ? Colors.redAccent : (hasStarted ? kActiveBlue : Colors.white), fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

void _showFinishDialog(BuildContext context) {
    final session = Provider.of<ActiveSessionProvider>(context, listen: false);
    
    // БЕРЕМ ИМЯ ИЗ СЕССИИ (то, что вверху экрана), а не из виджета
    final String currentName = session.currentRunningWorkout?.name ?? "NEW SESSION";

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF111111),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0xFFC5A059), width: 0.5),
        ),
        title: const Text("FINISH SESSION?", style: TextStyle(color: Color(0xFFC5A059))),
        content: Text("Results for '$currentName' will be added to your history.", 
          style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), 
            child: const Text("CANCEL", style: TextStyle(color: Colors.white24))
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFC5A059)),
            onPressed: () async {
              final navigator = Navigator.of(context);
              
              // ПЕРЕДАЕМ ИМЯ ИЗ ТЕКУЩЕЙ СЕССИИ
              await session.finishSession(currentName, context); 
              
              navigator.pop(); 
              navigator.pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const ActiveWorkoutScreen()),
                (route) => route.isFirst,
              );
            },
            child: const Text("SAVE", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
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
            Text(" SESSION DATA", style: TextStyle(color: kAntiqueGold.withOpacity(0.8), fontSize: 12)),
          ],
        ),
      );
    }
    return _buildRestRow(session);
  }

  Widget _buildRestRow(ActiveSessionProvider session) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(icon: const Icon(Icons.stop_circle_outlined, color: Colors.redAccent, size: 28), onPressed: () => session.stopRest()),
          Column(
            children: [
              Text(session.isManualRest ? "MANUAL REST" : "REST TIME", style: TextStyle(color: kAntiqueGold.withOpacity(0.8), fontSize: 9)),
              Text(_formatRestTime(session.restSecondsRemaining), style: TextStyle(color: kAntiqueGold, fontSize: 22, fontFamily: 'monospace')),
            ],
          ),
          IconButton(icon: Icon(Icons.touch_app_outlined, color: session.isManualRest ? const Color(0xFFFFAB00) : Colors.white38, size: 26), onPressed: () => session.toggleManualRest()),
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
            const Padding(
              padding: EdgeInsets.fromLTRB(25, 30, 25, 10), 
              child: Text("SESSION LOG", style: TextStyle(color: Color(0xFFFFAB00), fontSize: 12, fontWeight: FontWeight.bold))
            ),
            ...session.sessionLog.entries.map((entry) => _buildLogCard(entry)),
          ],
        );
      },
    );
  } 

  Widget _buildLogCard(MapEntry<String, List<ExerciseSet>> entry) {
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
          Text(entry.key.toUpperCase(), style: const TextStyle(color: Color(0xFFC0C0C0), fontSize: 13, fontWeight: FontWeight.w500)),
          const SizedBox(height: 12),
          ...entry.value.asMap().entries.map((setEntry) => _buildSetRow(setEntry, entry.key)),
        ],
      ),
    );
  }

  Widget _buildSetRow(MapEntry<int, ExerciseSet> setEntry, String exerciseName) { 
    final setData = setEntry.value;
    final String titleLower = exerciseName.toLowerCase();
    
    // Проверка на кардио (унифицированная)
    bool isCardio = titleLower.contains('run') || titleLower.contains('walk') || 
                    titleLower.contains('cycl') || titleLower.contains('elliptical') ||
                    titleLower.contains('stair') || titleLower.contains('step') || 
                    titleLower.contains('cardio');

    // БЕРЕМ ГОТОВУЮ ЦИФРУ ИЗ ПАМЯТИ (ту, что пришла с таймера)
    final String kcalValue = setData.kcal.toStringAsFixed(1);
    final String duration = "${setData.workDuration.inMinutes.toString().padLeft(2, '0')}:${(setData.workDuration.inSeconds % 60).toString().padLeft(2, '0')}";

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(isCardio ? "SESSION" : "SET ${setEntry.key + 1}", 
                  style: const TextStyle(color: Color(0xFFC0C0C0), fontSize: 15, fontWeight: FontWeight.w300)),
              Text(duration, style: TextStyle(color: const Color(0xFFC5A059).withOpacity(0.5), fontSize: 10, fontFamily: 'monospace')),
            ],
          ),
          const Spacer(),
          if (isCardio) 
             _metric(duration, "min")
          else ...[
             _metric("${setData.weight.toInt()}", "kg"),
             const SizedBox(width: 10),
             _metric("${setData.reps}", "reps"),
          ],
          const SizedBox(width: 15),
          _metric(kcalValue, "kcal"),
        ],
      ),
    );
  }

  Widget _metric(String value, String label) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(value, style: const TextStyle(color: Color(0xFFC0C0C0), fontSize: 16, fontFamily: 'monospace')),
        const SizedBox(width: 2),
        Text(label, style: const TextStyle(color: Colors.white38, fontSize: 10)),
      ],
    );
  }
}