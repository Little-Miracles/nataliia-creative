import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_body_life/providers/metrics_provider.dart';
import 'package:smart_body_life/providers/active_session_provider.dart'; // Добавили связь с сессией

class ActivityTimerScreen extends StatefulWidget {
  final dynamic exercise; 
  const ActivityTimerScreen({super.key, required this.exercise});

  @override
  State<ActivityTimerScreen> createState() => _ActivityTimerScreenState();
}

class _ActivityTimerScreenState extends State<ActivityTimerScreen> {
  final Color kAccentColor = const Color(0xFFFFAB00);
  Timer? _timer;
  int _seconds = 0;
  bool _isRunning = true;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_isRunning && mounted) setState(() => _seconds++);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // Вспомогательный метод для получения MET в зависимости от названия
  double _getMetValue(String name) {
    String n = name.toLowerCase();
    // Ищем только английские названия (как они у тебя в базе)
    if (n.contains('run') || n.contains('tread')) return 10.0; // Бег / Дорожка
    if (n.contains('walk')) return 3.5;                         // Ходьба
    if (n.contains('cycl') || n.contains('bike')) return 7.5;  // Велосипед
    if (n.contains('elliptical') || n.contains('orbit')) return 9.0; // Эллипс
    return 6.0; // Значение по умолчанию для всего остального
  }

  @override
  Widget build(BuildContext context) {
    // 1. Берем вес пользователя (из твоего MetricsProvider)
    final metrics = context.watch<MetricsProvider>();
    double userWeight = 70.0; // Стандарт, если веса нет в профиле
    
    // 2. Определяем имя и MET
    String displayName = widget.exercise.name ?? widget.exercise.title ?? "ACTIVITY";
    double met = _getMetValue(displayName);

    // 3. ЗОЛОТАЯ ФОРМУЛА (Apple/Garmin стандарт)
    // Kcal = (MET * 3.5 * weight / 200) * minutes
    double minutes = _seconds / 60;
    double burned = (met * 3.5 * userWeight / 200) * minutes;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Text(displayName.toUpperCase(), 
                  style: TextStyle(color: kAccentColor, fontWeight: FontWeight.w900, fontSize: 22, letterSpacing: 2)),
                const Text("LIVE ACTIVITY SESSION", style: TextStyle(color: Colors.white38, fontSize: 12)),
              ],
            ),
            
            Text(
              Duration(seconds: _seconds).toString().split('.').first.padLeft(8, "0"),
              style: const TextStyle(color: Colors.white, fontSize: 55, fontWeight: FontWeight.w200, fontFamily: 'monospace'),
            ),

            Column(
              children: [
                Text(burned.toStringAsFixed(1), 
                  style: TextStyle(color: kAccentColor, fontSize: 50, fontWeight: FontWeight.bold)),
                const Text("BURNED KCAL", style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.bold)),
              ],
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => setState(() => _isRunning = !_isRunning),
                      style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.white24), padding: const EdgeInsets.symmetric(vertical: 20), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))),
                      child: Text(_isRunning ? "PAUSE" : "RESUME", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: ElevatedButton(
                      // Внутри ElevatedButton (кнопка FINISH)
onPressed: () {
  metrics.updateBurned(burned);
  
  context.read<ActiveSessionProvider>().saveSetToNotebook(
    displayName, 
    0.0, 
    0,   
    Duration.zero, 
    Duration(seconds: _seconds), 
    burned, // <-- ВОТ ОН, 6-й АРГУМЕНТ! Передаем посчитанные калории
  );

  Navigator.pop(context);
},
                      style: ElevatedButton.styleFrom(backgroundColor: kAccentColor, padding: const EdgeInsets.symmetric(vertical: 20), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))),
                      child: const Text("FINISH", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}