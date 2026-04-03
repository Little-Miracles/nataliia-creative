import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:smart_body_life/providers/metrics_provider.dart';

// Добавили состояние finished
enum TimerState { idle, running, resting, paused, finished }

class LiveActionTimerScreen extends StatefulWidget {
  final String exercise;
  
  const LiveActionTimerScreen({super.key, required this.exercise});

  @override
  State<LiveActionTimerScreen> createState() => _LiveActionTimerScreenState();
}

class _LiveActionTimerScreenState extends State<LiveActionTimerScreen> {
  Timer? _timer;
  Timer? _restTimer;
  TimerState _state = TimerState.idle;

  int _seconds = 0;
  int _restSeconds = 45;

  final Color gemGold = const Color(0xFFD4AF37);
  final Color panelGrey = const Color(0xFF111111);
  final Color silverText = const Color(0xFFE0E0E0);
  // Глубокий антрацит (оставляем как базу)
  final Color anthracite = const Color(0xFF111111);
  final Color eerieBlack = const Color(0xFF1A1A1A); // Тот самый глубокий антрацит
  // Состаренное золото (Old Gold / Antique Brass)
  // Более темный, горчичный подтон с эффектом патины
  final Color agedGold = const Color(0xFFCFB53B); 

  // Благородное серебро (Silver / Slate Silver)
  // Матовый стальной оттенок, не слишком яркий, чтобы не «резал» глаз
  final Color silver = const Color(0xFFC0C0C0);

  // --- ТОТ САМЫЙ КВАДРАТНЫЙ И ТОНКИЙ СТИЛЬ ---
  TextStyle _sairaStyle({required Color color, required double fontSize, FontWeight weight = FontWeight.w100}) {
  return GoogleFonts.saira(
    color: color,
    fontSize: fontSize,
    fontWeight: weight,
    letterSpacing: 1.5, // Тот самый интервал для эффекта квадратности
  );
}

  // ===================== ЛОГИКА =====================

  void _start() {
    _restTimer?.cancel();
    HapticFeedback.lightImpact();
    setState(() {
      _state = TimerState.running;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _seconds++);
    });
  }

  void _pause() {
    _timer?.cancel();
    HapticFeedback.selectionClick();
    setState(() => _state = TimerState.paused);
  }

  void _startRest() {
    _timer?.cancel();
    HapticFeedback.mediumImpact();
    setState(() => _state = TimerState.resting);
    _restTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        if (_restSeconds > 0) _restSeconds--;
        else _endRest();
      });
    });
  }

  void _endRest() {
    _restTimer?.cancel();
    HapticFeedback.vibrate();
    _restSeconds = 45;
    _start();
  }

  void _finishAttempt() {
    _timer?.cancel();
    _restTimer?.cancel();
    HapticFeedback.heavyImpact();
    setState(() {
      _state = TimerState.finished; // Переходим в режим финиша на этом же экране
    });
  }

  double _getMetValue(String name) {
    String n = name.toUpperCase();
    if (n.contains("WATER") || n.contains("SWIM")) return 8.0;
    if (n.contains("RUN")) return 10.0;
    return 4.5;
  }

  @override
  void dispose() {
    _timer?.cancel();
    _restTimer?.cancel();
    super.dispose();
  }

  // ===================== ВИЗУАЛ (ОДИН ЭКРАН) =====================

  @override
  Widget build(BuildContext context) {
    final metrics = context.watch<MetricsProvider>();
    double userWeight = 75.0; 
    double met = _getMetValue(widget.exercise);
    double burned = (met * 3.5 * userWeight / 200) * (_seconds / 60);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.exercise, style: TextStyle(color: agedGold, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white), 
          onPressed: () => Navigator.pop(context)
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              // 1. ВЕРХНЯЯ ЧАСТЬ: Кубок (появляется только на финише)
              const SizedBox(height: 10),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 500),
                opacity: _state == TimerState.finished ? 1.0 : 0.0,
                child: Column(
                  children: [
                    Icon(Icons.workspace_premium, color: agedGold, size: 50),
                    Text("WORKOUT COMPLETE", 
                      style: TextStyle(color: agedGold, fontSize: 16, fontWeight: FontWeight.w900, letterSpacing: 2)),
                  ],
                ),
              ),
// 1. Сначала идет надпись (Label)
Text(
  "STOPWATCH", // Твой текст
  style: _sairaStyle(
    color: silverText.withOpacity(0.9), // Делаем её тусклой, чтобы не отвлекала
    fontSize: 20, 
    weight: FontWeight.w200
  ),
),

const SizedBox(height: 0.5), // Маленький зазор, чтобы надпись "прилипла" к часам
              // 2. ЦЕНТР: Панель Часов
              Expanded(
                child: Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 30),
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    constraints: const BoxConstraints(maxWidth: 400, maxHeight: 200),
                    decoration: BoxDecoration(
                      color: panelGrey,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: agedGold.withOpacity(0.4), width: 1.5),
                    ),
                    child: Center(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          _state == TimerState.resting ? _formatRestTime(_restSeconds) : _formatTime(_seconds),
                          style: _sairaStyle(
                            color: _state == TimerState.resting ? Colors.greenAccent : silverText,
                            fontSize: 100,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
// НАДПИСЬ НАД КАЛОРИЯМИ
Text("BURNED CALORIES", 
  style: _sairaStyle(color: silverText.withOpacity(0.9), fontSize: 16, weight: FontWeight.w200)),
const SizedBox(height: 1),
              // 3. ПАНЕЛЬ КАЛОРИЙ (Всегда на месте, меняет цвет)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 60),
                padding: const EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                  color: (_state == TimerState.finished || _state == TimerState.running) ? gemGold : panelGrey,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: gemGold.withOpacity(0.3)),
                ),
                child: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
  burned.toStringAsFixed(1), 
  style: _sairaStyle(
    // ВОТ ПРАВКА: Текст становится ТЕМНО-СЕРЫМ, когда фон ЗОЛОТОЙ
    color: (_state == TimerState.finished || _state == TimerState.running) 
        ? eerieBlack // Твой глубокий антрацит
        : Colors.white24, // Серый для неактивного состояния
    fontSize: 40, 
    weight: FontWeight.w400, // Сделаем чуть жирнее для контраста
    // weight: FontWeight.w200, // Если хочешь оставить тонкий, как раньше
  ),
),
      const SizedBox(width: 8),
      const Icon(Icons.local_fire_department, color: Color.fromARGB(255, 203, 121, 6), size: 28), // Огонек внутри
    ],
  ),
),
    
              //const SizedBox(height: 8),
              //Icon(Icons.local_fire_department, color: gemGold, size: 24),
              
              // Золотой лейбл (только на финише)
              if (_state == TimerState.finished)
                const Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Text("GOLD LAB MANUAL", style: TextStyle(color: Color(0xE6BE8A), fontSize: 10, letterSpacing: 1)),
                ),

              const SizedBox(height: 30),

              // 4. НИЖНЯЯ ЧАСТЬ: Кнопки
              Padding(
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.05),
                child: _state == TimerState.finished 
                  ? _buildSaveButton() 
                  : _buildButtons(burned),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Кнопка сохранения (появляется в конце)
Widget _buildSaveButton() {
    // Получаем доступ к провайдеру для записи данных
    final metricsProvider = Provider.of<MetricsProvider>(context, listen: false);
    
    // Рассчитываем финальные калории еще раз для точности
    double userWeight = 75.0; 
    double met = _getMetValue(widget.exercise);
    double finalBurned = (met * 3.5 * userWeight / 200) * (_seconds / 60);

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: gemGold,
        minimumSize: const Size(220, 60),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      onPressed: () {
        HapticFeedback.heavyImpact();
        
        
        // ВОТ ОН, КАБЕЛЬ: Отправляем калории в общую систему (Analytics и Gym)
        metricsProvider.addBurnedCalories(finalBurned);
        
        // Закрываем экран и возвращаемся в Хаб
        Navigator.pop(context);
      },
      child: const Text("FINISH & SAVE", 
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
    );
  }

  Widget _buildButtons(double burned) {
    switch (_state) {
      case TimerState.idle:
        return _btn(_start, Icons.play_arrow, Colors.green);
      case TimerState.running:
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _btn(_pause, Icons.pause, Colors.orange),
            _btn(_startRest, Icons.timer_outlined, Colors.blue),
            _btn(_finishAttempt, Icons.stop, Colors.red),
          ],
        );
      case TimerState.paused:
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _btn(_start, Icons.play_arrow, Colors.green),
            _btn(_finishAttempt, Icons.stop, Colors.red),
          ],
        );
      case TimerState.resting:
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _btn(() => setState(() => _restSeconds += 30), Icons.add, Colors.blue),
            _btn(_endRest, Icons.skip_next, Colors.green),
          ],
        );
      default:
        return const SizedBox();
    }
  }

  Widget _btn(VoidCallback onTap, IconData icon, Color col) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: col.withOpacity(0.5), width: 2),
        ),
        child: Icon(icon, color: col, size: 35),
      ),
    );
  }

  String _getStatusText() {
    if (_state == TimerState.running) return "WORKOUT IN PROGRESS";
    if (_state == TimerState.resting) return "REST TIME";
    if (_state == TimerState.paused) return "PAUSED";
    if (_state == TimerState.finished) return "GO TO ARCHIVE";
    return "READY TO START";
  }

  String _formatTime(int sec) {
    return "${(sec ~/ 3600).toString().padLeft(2, '0')}:${((sec % 3600) ~/ 60).toString().padLeft(2, '0')}:${(sec % 60).toString().padLeft(2, '0')}";
  }

  String _formatRestTime(int sec) => "00:00:${sec.toString().padLeft(2, '0')}";
}