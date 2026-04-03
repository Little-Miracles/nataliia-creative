import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/metrics_provider.dart';
import 'calc_screen.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});
  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  // ==========================================
  // 🔩 ПАЛИТРА "ГРАФИТ, СТАЛЬ & САПФИР"
  // ==========================================
  static const Color gemBackground = Color(0xFF050505); // Глубокий черный (уголь)
  static const Color gemSteel = Color(0xFF1C1E20);      // Основной цвет стали
  static const Color gemSteelLight = Color(0xFF2A2D31); // Светлый блик металла
  static const Color gemGold = Color(0xFFFFD700);       // Горящее золото
  static const Color gemEmeraldLight = Color(0xFF00FF9D); // Неоновый изумруд
  static const Color gemSapphire = Color(0xFF082567);    // Глубокий сапфир

  void _openCalculator() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CalcScreen()),
    );
    if (result != null && result is CalcData) {
      if (!mounted) return;
      context.read<MetricsProvider>().updateFromCalculator(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final metrics = context.watch<MetricsProvider>();

    return Scaffold(
      backgroundColor: gemBackground, 
      appBar: AppBar(
        title: const Text('ANALYTICS', 
          style: TextStyle(color: gemGold, fontWeight: FontWeight.bold, letterSpacing: 2)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: gemGold.withAlpha(40),
              child: IconButton(
                icon: const Icon(Icons.calculate, color: gemGold, size: 20),
                onPressed: _openCalculator,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white38, size: 20),
            onPressed: () => metrics.resetDailyMetrics(), 
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          children: [
            _buildPeriodSelector(metrics),
            const SizedBox(height: 12),
            _buildScientificChart(metrics),
            const SizedBox(height: 12),
            _buildCompactGrid(metrics),
            const SizedBox(height: 12),
            _buildTargetPanel(metrics),
            const SizedBox(height: 15),
            _buildYearlyAchievement(metrics),
            const SizedBox(height: 40),
          ],
          
        ),
      ),
    );
  }

  Widget _buildPeriodSelector(MetricsProvider metrics) {
    List<String> periods = ['WEEK', 'MONTH', '3 MONTHS', '6 MONTHS', 'YEAR'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: periods.map((p) {
        bool isSel = metrics.selectedPeriod == p;
        return GestureDetector(
          onTap: () => metrics.setPeriod(p),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isSel ? gemGold : gemSteel,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: isSel ? gemGold : Colors.white10),
              boxShadow: isSel ? [BoxShadow(color: gemGold.withAlpha(50), blurRadius: 10)] : null,
            ),
            child: Text(p, style: TextStyle(
              color: isSel ? Colors.black : Colors.white54,
              fontSize: 9, fontWeight: FontWeight.bold
            )),
          ),
        );
      }).toList(),
    );
  }

Widget _buildScientificChart(MetricsProvider metrics) {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: gemSteel,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
        boxShadow: const [BoxShadow(color: Colors.black, blurRadius: 15, offset: Offset(0, 8))],
      ),
      child: Column(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(7, (index) {
                DateTime date = DateTime.now().subtract(Duration(days: 6 - index));
                String key = DateFormat('yyyy-MM-dd').format(date);
                double eaten = metrics.weeklyHistory[key]?['eaten'] ?? 0.0;
                double burned = metrics.weeklyHistory[key]?['burned'] ?? 0.0;
                
                return _DualBar(
                  label: DateFormat('E').format(date).toUpperCase(), 
                  eaten: eaten,
                  burned: burned,
                  isToday: key == DateFormat('yyyy-MM-dd').format(DateTime.now()),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactGrid(MetricsProvider metrics) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      mainAxisSpacing: 8, crossAxisSpacing: 12,
      childAspectRatio: 1.0, 
      children: [
        _Tile('EATEN', '${metrics.eatenToday.toInt()}', '${metrics.dailyCaloriesLimit}', Icons.lunch_dining, gemGold),
        _Tile('BURNED', '${metrics.burnedToday.toInt()}', '500', Icons.local_fire_department, Colors.orangeAccent),
        _Tile('WATER', '${metrics.waterToday}', '${metrics.targetWater}', Icons.water_drop, Colors.blueAccent),
        _Tile('PROTEIN', '${metrics.proteinToday.toInt()}', '${metrics.targetProtein.toInt()}', Icons.fitness_center, gemEmeraldLight),
        _Tile('CARBS', '${metrics.carbsToday.toInt()}', '${metrics.targetCarbs.toInt()}', Icons.bakery_dining, gemGold),
        _Tile('FATS', '${metrics.fatsToday.toInt()}', '${metrics.targetFats.toInt()}', Icons.opacity, Colors.orange),
      ],
    );
  }

  Widget _Tile(String title, String fact, String goal, IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(
        // ОБЪЕМНЫЙ ЭФФЕКТ: Градиент создает выпуклость
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [gemSteelLight, gemSteel, Color(0xFF0F0F0F)],
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          // Глубокая тень снизу
          BoxShadow(color: Colors.black.withAlpha(180), blurRadius: 8, offset: const Offset(4, 4)),
          // Тонкий блик сверху для эффекта грани
          BoxShadow(color: Colors.white.withAlpha(10), blurRadius: 1, offset: const Offset(-1, -1)),
        ],
        border: Border.all(color: Colors.white.withAlpha(5), width: 0.5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color.withAlpha(200), size: 16),
          const SizedBox(height: 6),
          Text(fact, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          Text('GOAL: $goal', style: const TextStyle(color: Colors.white38, fontSize: 8)),
          const SizedBox(height: 6),
          Text(title, style: TextStyle(color: gemGold.withAlpha(180), fontSize: 8, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
        ],
      ),
    );
  }

  Widget _buildTargetPanel(MetricsProvider metrics) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [gemSapphire, gemBackground],
          begin: Alignment.topLeft, end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: gemSapphire.withAlpha(120)),
      ),
      child: Column(
        children: [
          _TargetRow('WEIGHT', metrics.currentWeight, metrics.targetWeight, 'kg'),
          const Divider(color: Colors.white10, height: 20),
          _TargetRow('CALORIES', metrics.eatenToday, metrics.dailyCaloriesLimit.toDouble(), 'kcal'),
        ],
      ),
    );
  }

  Widget _TargetRow(String title, double fact, double target, String unit) {
    double delta = fact - target;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween, 
      children: [
        Text(title, style: const TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold)),
        Row(
          children: [
            Text('${fact.toInt()} ', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
            Text('/ ${target.toInt()} $unit', style: const TextStyle(color: Colors.white24, fontSize: 11)),
            const SizedBox(width: 10),
            Text('${delta > 0 ? "+" : ""}${delta.toInt()}', 
              style: TextStyle(color: delta > 0 ? Colors.redAccent : gemEmeraldLight, fontSize: 11, fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }

  Widget _buildYearlyAchievement(MetricsProvider metrics) {
    if (metrics.isYearPassed) return const SizedBox.shrink();
    return Column(
      children: [
        const Text('ANNUAL REPORT PROGRESS: 0%', 
          style: TextStyle(color: Colors.white24, fontSize: 9, letterSpacing: 1)),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity, 
          child: OutlinedButton.icon(
            onPressed: _openCalculator,
            icon: const Icon(Icons.calculate_outlined, color: gemGold),
            label: const Text('OPEN CALCULATOR', style: TextStyle(color: gemGold, fontWeight: FontWeight.bold)),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: gemGold),
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
      ],
    );
  }
}

class _DualBar extends StatelessWidget {
  final String label; final double eaten, burned; final bool isToday;
  const _DualBar({required this.label, required this.eaten, required this.burned, this.isToday = false});

  @override
  Widget build(BuildContext context) {
    // Высота столбиков (масштаб до 1000 ккал)
    double h1 = (eaten / 500) * 120;
    if (h1 > 120) h1 = 105; // Еда может быть выше, но не будет превышать 120 пикселей
    double h2 = (burned / 500) * 120;
    if (h2 > 100) h2 = 100;

    double barWidth = eaten > 500 ? 12.0 : 7.0;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // 1. ЦИФРА ЕДЫ (Всегда сверху)
        SizedBox(
          height: 15, // Фиксируем место, чтобы не прыгало
          child: eaten > 0 
            ? Text('${eaten.toInt()}', style: TextStyle(color: isToday ? const Color(0xFF00FF9D) : Colors.white30, fontSize: 8, fontWeight: FontWeight.bold))
            : const SizedBox(),
        ),
        const SizedBox(height: 4),

        // 2. СТОЛБИКИ
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              width: barWidth, 
              height: h1 < 4 ? 4 : h1, 
              decoration: BoxDecoration(
                color: isToday ? const Color(0xFF00FF9D) : const Color(0xFF00FF9D).withAlpha(100), 
                borderRadius: BorderRadius.circular(2),
              )
            ),
            const SizedBox(width: 3),
            Container(
              width: 6, 
              height: h2 < 4 ? 4 : h2, 
              decoration: BoxDecoration(
                color: isToday ? const Color(0xFFFFD700) : const Color(0xFFFFD700).withAlpha(100), 
                borderRadius: BorderRadius.circular(2),
              )
            ),
          ],
        ),
        
        const SizedBox(height: 6),

        // 3. ЦИФРА ТРЕНИРОВКИ (Всегда есть, чтобы держать линию!)
        SizedBox(
          height: 12,
          child: Text(
            burned > 0 ? '${burned.toInt()}' : '0', // Если пусто — пишем 0
            style: TextStyle(
              color: burned > 0 ? const Color(0xFFFFD700) : Colors.white10, // 0 будет почти невидимым
              fontSize: 8, 
              fontWeight: FontWeight.bold
            ),
          ),
        ),

        const SizedBox(height: 8),

        // 4. ДЕНЬ НЕДЕЛИ (Теперь всегда на одной линии)
        Text(
          label,
          style: TextStyle(
            color: isToday ? const Color(0xFFFFD700) : Colors.white38, 
            fontSize: 9, 
            fontWeight: FontWeight.bold
          ),
        ),
      ],
    );
  }
}