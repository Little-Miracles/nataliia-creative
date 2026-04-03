import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OutdoorFinishScreen extends StatelessWidget {
  final String exercise;
  final int totalSeconds;
  final double burnedKcal;

  const OutdoorFinishScreen({
    super.key,
    required this.exercise,
    required this.totalSeconds,
    required this.burnedKcal,
  });

  @override
  Widget build(BuildContext context) {
    const Color gemGold = Color(0xFFD4AF37);

    return Scaffold(
      backgroundColor: Colors.black, // ЧИСТО ЧЕРНЫЙ ФОН
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.workspace_premium, color: gemGold, size: 80),
            const SizedBox(height: 20),
            Text("WORKOUT COMPLETE", 
              style: TextStyle(color: gemGold, fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: 2)),
            const SizedBox(height: 40),
            
            // Время
            _buildStat("TOTAL TIME", _formatTime(totalSeconds)),
            const SizedBox(height: 20),
            
            // Калории
          // Калории (с золотым лейблом)
            Column(
              children: [
                _buildStat("ENERGY BURNED", "${burnedKcal.toStringAsFixed(1)} KCAL"),
                const SizedBox(height: 5),
                // ВОТ ЗОЛОТОЙ ЛЕЙБЛ С КНИЖЕЧКОЙ (Твой запрос)
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.local_fire_department, color: gemGold, size: 16),
                    SizedBox(width: 5),
                    Text("GOLD LAB MANUAL", style: TextStyle(color: gemGold, fontSize: 10, letterSpacing: 1)),
                  ],
                ),
              ],
            ),
            
            const SizedBox(height: 80),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: gemGold,
                  minimumSize: const Size(double.infinity, 60),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                onPressed: () {
  HapticFeedback.heavyImpact();
  // Мы возвращаемся на 2 шага назад: 
  // 1. С финишного экрана в таймер (виртуально)
  // 2. Из таймера обратно в список Outdoor/Water.
  int count = 0;
  Navigator.of(context).popUntil((_) => count++ >= 1);
},
                child: const Text("FINISH & SAVE", 
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }

// --- ЧИСТЫЕ ПАНЕЛЬКИ С ТОНКИМИ ЦИФРАМИ КАК НА СКРИНАХ ---
Widget _buildStat(String label, String value) {
  // Наша палитра из скрина 2
  const Color panelGrey = Color(0xFF111111); // Фон панельки
  const Color goldBorder = Color(0xFFD4AF37); // Золотой бордер
  const Color silverText = Color(0xFFE0E0E0); // Серебристые цифры

  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
    padding: const EdgeInsets.symmetric(vertical: 20),
    decoration: BoxDecoration(
      color: panelGrey,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: goldBorder.withOpacity(0.4), width: 1), // Тонкий бордер
    ),
    child: Column(
      children: [
        // Текст лейбла (напр. TOTAL TIME)
        Text(
          label, 
          style: TextStyle(color: silverText.withOpacity(0.5), fontSize: 10, letterSpacing: 1.5, fontWeight: FontWeight.bold)
        ),
        const SizedBox(height: 8),
        // Сами цифры (тонкие, серебристые)
        Text(
          value, 
          style: const TextStyle(
            color: silverText, 
            fontSize: 45, 
            fontWeight: FontWeight.w100, // <--- ЭКСТРЕМАЛЬНО ТОНКИЙ
            letterSpacing: 1.5,
          ),
        ),
      ],
    ),
  );
}

  String _formatTime(int sec) {
    int h = sec ~/ 3600;
    int m = (sec % 3600) ~/ 60;
    int s = sec % 60;
    return "${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}";
  }
}