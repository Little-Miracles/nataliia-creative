import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_body_life/providers/metrics_provider.dart'; //

class SmartOrangeBanner extends StatefulWidget {
  const SmartOrangeBanner({super.key});

  @override
  State<SmartOrangeBanner> createState() => _SmartOrangeBannerState();
}

class _SmartOrangeBannerState extends State<SmartOrangeBanner> {
  // Точка отсчета для прогресс-бара веса
  double startWeight = 80.0;   

  // Окошко для ручного ввода веса
  void _showWeightDialog(BuildContext context, {required bool isTarget}) {
    final metrics = Provider.of<MetricsProvider>(context, listen: false);
    final TextEditingController controller = TextEditingController(
      text: (isTarget ? metrics.targetWeight : metrics.currentWeight).toString()
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E2D24),
        title: Text(isTarget ? "Target Goal" : "Current Weight", 
                   style: const TextStyle(color: Colors.white, fontSize: 18)),
        content: TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          style: const TextStyle(color: Colors.white, fontSize: 24),
          decoration: const InputDecoration(
            suffixText: "kg",
            suffixStyle: TextStyle(color: Colors.white70),
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFFFF6600))),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("CANCEL")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF6600)),
            onPressed: () {
              double val = double.tryParse(controller.text) ?? 0;
              metrics.updateWeight(val, isTarget: isTarget); //
              Navigator.pop(context);
            },
            child: const Text("SAVE"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 1. Подключаем наш хаб данных
    final metrics = context.watch<MetricsProvider>(); 
    
    // 2. Выгружаем все показатели (Никаких заглушек!)
    double currentWeight = metrics.currentWeight;
    double targetWeight = metrics.targetWeight;
    int food = metrics.eatenToday.toInt(); 
    int burned = metrics.burnedToday.round(); // Теперь 2.9 станет 3, а 0.6 станет 1
    int limit = metrics.dailyCaloriesLimit; //

    // 3. Арифметика "Спасательного круга"
    double accumulated = food.toDouble() - burned.toDouble(); // Съедено - Сожжено
    bool isOverLimit = accumulated > limit && limit > 0;

    // 4. Расчет прогресса веса
    double totalToLose = (startWeight - targetWeight).abs();
    double lostSoFar = (startWeight - currentWeight).abs();
    double progress = (totalToLose == 0) ? 0 : (lostSoFar / totalToLose).clamp(0.0, 1.0);
    double remaining = (currentWeight - targetWeight).abs();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        children: [
          // --- ИНФО-БАННЕР С НАПОМИНАНИЕМ ---
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFFFAB00).withOpacity(0.3)),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
  children: [
    Icon(Icons.info_outline, color: Color(0xFFFFAB00), size: 12),
    SizedBox(width: 6),
    // ОБЕРТКА ДЛЯ ТЕКСТА (чтобы он переносился)
    Expanded( 
      child: Text(
        "NOTE: 70KG BIOMETRIC STANDARD USED. SET ACTUAL WEIGHT FOR METABOLIC ACCURACY.",
        style: TextStyle(
          color: Color(0xFFFFAB00),
          fontSize: 10, // Чуть-чуть увеличил до 10 для читаемости, как вы и хотели
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
        ),
        // Убираем ограничение в одну строку
        softWrap: true, 
        overflow: TextOverflow.visible,
      ),
    ),
  ],
)
              ),
            ),

          // --- ВЕРХНЯЯ СТРОКА: ТЕКУЩИЙ ВЕС / КАЛОРИИ / ЦЕЛЬ ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Лево: Текущий вес
              GestureDetector(
                onTap: () => _showWeightDialog(context, isTarget: false),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(currentWeight.toStringAsFixed(1), 
                        style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
                    const Text('CURRENT (kg)', style: TextStyle(color: Colors.grey, fontSize: 9)),
                  ],
                ),
              ),
              
// Центр: Твоя Арифметика (Калории)
              Column(
                children: [
                  Text('🍎 $food - 🔥 $burned', style: const TextStyle(color: Colors.white54, fontSize: 11)),
                  const SizedBox(height: 2),
                  Text(
                    '${accumulated.toInt()}', 
                    style: TextStyle(
                      color: isOverLimit ? Colors.red : const Color(0xFFFF6600),
                      fontSize: 32, // Сделали число крупнее
                      fontWeight: FontWeight.w900,
                    )
                  ),
                  // Улучшенный блок ЛИМИТА
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05), // Легкая подложка
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'GOAL: $limit kcal', // Заменили мелкий "OF" на "GOAL"
                      style: const TextStyle(
                        color: Colors.white70, // Сделали текст ярче
                        fontSize: 12,          // Увеличили шрифт
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),

              // Право: Цель
              GestureDetector(
                onTap: () => _showWeightDialog(context, isTarget: true),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(targetWeight.toStringAsFixed(1), 
                        style: const TextStyle(color: Colors.white70, fontSize: 20, fontWeight: FontWeight.bold)),
                    const Text('GOAL (kg)', style: TextStyle(color: Colors.grey, fontSize: 9)),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // --- ПРОГРЕСС-БАР ВЕСА ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Progress: ${(progress * 100).toInt()}%', 
                  style: const TextStyle(color: Colors.white38, fontSize: 10)),
              Text('${remaining.toStringAsFixed(1)} kg to goal', 
                  style: const TextStyle(color: Color(0xFFFFAB00), fontSize: 10, fontWeight: FontWeight.bold)),
            ],
          ),
          
          const SizedBox(height: 6),

          Stack(
            children: [
              Container(
                height: 8,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              FractionallySizedBox(
                widthFactor: progress,
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFFFF9100), Color(0xFFFF3D00)]),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}