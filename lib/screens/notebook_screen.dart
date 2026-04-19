import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:smart_body_life/providers/active_session_provider.dart';
import 'package:smart_body_life/screens/active_workout_screen.dart';
import 'package:smart_body_life/screens/gym_screen.dart';
import 'package:smart_body_life/widgets/notebook_work_card.dart';


class NotebookScreen extends StatefulWidget {
  const NotebookScreen({super.key});

  @override
  State<NotebookScreen> createState() => _NotebookScreenState();
}

class _NotebookScreenState extends State<NotebookScreen> {
  Timer? _refreshTimer;
  final Color kAntiqueGold = const Color(0xFFC5A059);
  final Color kActiveBlue = const Color(0xFF2196F3);
  final Color kSilver = const Color(0xFFC0C0C0);

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
        final exercises = session.currentRunningWorkout?.exercises ?? [];

        return Scaffold(
          backgroundColor: Colors.black,
          appBar: _buildAppBar(session),
          body: Column(
            children: [
              _buildTopControls(session),
              _buildDateAndInfoRow(session), // Исправлено: теперь принимает session
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

  // --- ИНСТРУКЦИЯ (ONBOARDING) ---
  Widget _buildOnboarding(ActiveSessionProvider session) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
      alignment: Alignment.topCenter,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _onboardingStep(
            "1. Tap ", 
            "START SESSION", // Это выделим золотом
            session.isWorkoutActive,
            true,
          ),
          const SizedBox(height: 16),
          _onboardingStep(
            "2. Tap ", 
            "ADD GEAR", // И это тоже
            session.currentRunningWorkout?.exercises.isNotEmpty ?? false,
            session.isWorkoutActive,
          ),
        ],
      ),
    );
  }

  Widget _onboardingStep(String prefix, String buttonName, bool isDone, bool isActive) {
    return Opacity(
      opacity: isActive ? 1.0 : 0.3,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isDone ? Icons.check_circle : Icons.circle_outlined,
            color: isDone ? kAntiqueGold : Colors.white38,
            size: 22, // Увеличил иконку
          ),
          const SizedBox(width: 15),
          RichText(
            text: TextSpan(
              style: const TextStyle(
                fontSize: 14, // Увеличил шрифт
                fontWeight: FontWeight.w500, // Сделал чуть толще
                letterSpacing: 0.5,
              ),
              children: [
                TextSpan(text: prefix, style: const TextStyle(color: Colors.white70)),
                TextSpan(
                  text: buttonName, 
                  style: TextStyle(
                    color: kAntiqueGold, // Золотое название кнопки
                    fontWeight: FontWeight.w900, // Жирный акцент
                  )
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  // --- ВЕРХНЯЯ ПАНЕЛЬ (APPBAR) ---
  PreferredSizeWidget _buildAppBar(ActiveSessionProvider session) {
    return AppBar(
      backgroundColor: Colors.black,
      elevation: 0,
      toolbarHeight: 90,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
        onPressed: () => Navigator.pop(context),
      ),
      title: _buildTopTimer(session),
      actions: [
        if (session.currentRunningWorkout?.exercises.isNotEmpty ?? false)
          TextButton(
            onPressed: () => _showFinishDialog(context, session),
            child: const Text("FINISH",
                style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 16)),
          ),
      ],
    );
  }

  Widget _buildTopTimer(ActiveSessionProvider session) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("LIVE WORKOUT",
            style: TextStyle(
              color: kAntiqueGold.withOpacity(0.8),
              fontSize: 14,
              fontWeight: FontWeight.w300,
              letterSpacing: 2.5,
            )),
        const SizedBox(height: 8),
        Text(
          _formatDuration(session.totalTime),
          style: TextStyle(
            color: kAntiqueGold,
            fontSize: 34,
            fontFamily: 'monospace',
            fontWeight: FontWeight.w200,
            fontFeatures: const [FontFeature.tabularFigures()],
            letterSpacing: 2.0,
          ),
        ),
      ],
    );
  }

// --- УПРАВЛЕНИЕ (START / ADD GEAR) ---
  Widget _buildTopControls(ActiveSessionProvider session) {
    final bool isTimerRunning = session.isTimerRunning;
    final bool hasStarted = session.totalTime.inSeconds > 0;
    
    // Новое условие: если начали, но сейчас таймер СТОИТ — включаем красный режим
    final bool isPaused = hasStarted && !isTimerRunning;

    // Определяем цвет: 
    // Если пауза — красный, если работает — синий, если еще не начинали — золото
    Color statusColor = isPaused 
        ? Colors.redAccent 
        : (hasStarted ? kActiveBlue : kAntiqueGold);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => session.stopWorkout(),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  // Рамка теперь меняет цвет на красный при паузе
                  border: Border.all(color: statusColor, width: 1.5),
                ),
                alignment: Alignment.center,
                child: Text(
                  !hasStarted ? "START SESSION" : (isTimerRunning ? "STOP TIMER" : "RESUME"),
                  style: TextStyle(
                    // Текст тоже становится красным (или белым, если хочешь больше контраста)
                    color: isPaused ? Colors.redAccent : (hasStarted ? kActiveBlue : Colors.white),
                    fontWeight: isPaused ? FontWeight.bold : FontWeight.w400,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Opacity(
              opacity: session.isWorkoutActive ? 1.0 : 0.3,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(0, 48),
                  side: BorderSide(color: kAntiqueGold.withOpacity(0.5)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  if (session.isWorkoutActive) {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const GymScreen()));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please start the workout timer first")),
                    );
                  }
                },
                icon: Icon(Icons.add, color: kAntiqueGold, size: 18),
                label: Text("ADD GEAR",
                    style: TextStyle(color: kSilver, fontWeight: FontWeight.w300, fontSize: 13)),
              ),
            ),
          ),
        ],
      ),
    );
  }
  // --- ПОЛОСА ДАТЫ / ПУЛЬТ ОТДЫХА ---
  Widget _buildDateAndInfoRow(ActiveSessionProvider session) {
    if (!session.isResting) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(25, 20, 25, 10),
        child: Row(
          children: [
            Text("${DateTime.now().day}.${DateTime.now().month}.${DateTime.now().year}",
                style: const TextStyle(color: Colors.white70, fontSize: 13, letterSpacing: 0.5)),
            const Spacer(),
            Icon(Icons.bolt, color: kAntiqueGold.withOpacity(0.8), size: 16),
            const SizedBox(width: 4),
            Text(" SESSION DATA",
                style: TextStyle(
                    color: kAntiqueGold.withOpacity(0.8),
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 1.0)),
          ],
        ),
      );
    }

    return Padding( // Вместо Container используем Padding
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: Row( // Убрали BoxDecoration (цвет и бордер исчезнут)
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: const Icon(Icons.stop_circle_outlined, color: Colors.redAccent, size: 28),
            onPressed: () => session.stopRest(),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(session.isManualRest ? "MANUAL REST" : "REST TIME",
                  style: TextStyle(
                      color: kAntiqueGold.withOpacity(0.8),
                      fontSize: 9,
                      letterSpacing: 1.5)),
              const SizedBox(height: 2),
              Text(
                _formatRestTime(session.restSecondsRemaining),
                style: TextStyle(
                  color: kAntiqueGold,
                  fontSize: 22,
                  fontWeight: FontWeight.w200,
                  fontFeatures: const [FontFeature.tabularFigures()],
                  fontFamily: 'monospace',
                ),
              ),
            ],
          ),
          IconButton(
            icon: Icon(Icons.touch_app_outlined,
                color: session.isManualRest ? const Color(0xFFFFAB00) : Colors.white38, size: 26),
            onPressed: () => session.toggleManualRest(),
          ),
        ],
      ),
    );
  }

  String _formatRestTime(int totalSeconds) {
    int mins = totalSeconds ~/ 60;
    int secs = totalSeconds % 60;
    return "${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}";
  }

void _showFinishDialog(BuildContext context, ActiveSessionProvider session) {
    // Контроллер для ввода имени
    final TextEditingController nameController = TextEditingController(text: "");

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF111111),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text("FINISH & SAVE SESSION?", style: TextStyle(color: kAntiqueGold)),
        
        content: TextField(
          controller: nameController,
          autofocus: true, // Добавим это, чтобы клавиатура открывалась сразу
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            // Здесь пишем подсказку (hint), которая исчезнет, когда начнешь писать
            hintText: "ENTER WORKOUT NAME",
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.2)),
            labelText: "WORKOUT NAME",
            labelStyle: TextStyle(color: kAntiqueGold.withOpacity(0.5)),
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: kAntiqueGold)),
            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: kActiveBlue)),
          ),
        ),

        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), 
            child: const Text("CANCEL", style: TextStyle(color: Colors.white24))
          ),
          
          // Внутри твоего файла NotebookScreen, в методе _showFinishDialog:

          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: kAntiqueGold),
            onPressed: () async { // Добавь слово async
              final navigator = Navigator.of(context);
              
              // ГЛАВНОЕ: Ждём (await), пока Провайдер доделает свою работу!
              await session.finishSession(nameController.text, context); 
              
              navigator.pop(); 

              navigator.pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const ActiveWorkoutScreen()),
                (route) => route.isFirst,
              );
            },
            child: const Text("FINISH", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return "${twoDigits(d.inMinutes)}:${twoDigits(d.inSeconds.remainder(60))}";
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
                      
                      // БОЛЬШЕ НИКАКИХ ФОРМУЛ ТУТ! Берем готовую цифру kcal.
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