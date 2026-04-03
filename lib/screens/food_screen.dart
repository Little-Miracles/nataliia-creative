import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_body_life/providers/metrics_provider.dart';
import 'package:smart_body_life/screens/bio_match_screen.dart';
import 'package:smart_body_life/screens/food_category_screen.dart';
import 'package:smart_body_life/screens/meal_detail_screen.dart';

class FoodScreen extends StatefulWidget {
  const FoodScreen({super.key});

  @override
  State<FoodScreen> createState() => _FoodScreenState();
}

class _FoodScreenState extends State<FoodScreen> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // РЕЗИНОВАЯ ЕДИНИЦА
    double unit = MediaQuery.of(context).size.width / 100;
    final metrics = context.watch<MetricsProvider>();
    const Color gold = Color(0xFFD4AF37);
    
    return Scaffold(
      backgroundColor: const Color(0xFF05100A), 
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: gold, size: unit * 4),
          onPressed: () => Navigator.pop(context),
        ),  
        title: Text('SMART KITCHEN', 
          style: TextStyle(color: gold, fontWeight: FontWeight.bold, letterSpacing: 1, fontSize: unit * 4.5)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // 1. ЦЕНТРАЛЬНАЯ ПАНЕЛЬ (МОНИТОР) - РЕЗИНОВАЯ
          Container(
            margin: EdgeInsets.fromLTRB(unit * 4, unit * 2, unit * 4, unit * 1),
            padding: EdgeInsets.all(unit * 4),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF001A10), Color(0xFF000000)], 
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(unit * 5),
              border: Border.all(color: gold.withOpacity(0.2), width: 0.8),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _StatColumn(title: 'EATEN', value: '${metrics.eatenToday.toInt()}', color: Colors.white, unit: unit),
                    _StatColumn(title: 'TARGET', value: '${metrics.dailyCaloriesLimit}', color: gold, isMain: true, unit: unit),
                    _StatColumn(title: 'REMAINING', value: '${(metrics.dailyCaloriesLimit - metrics.eatenToday).toInt()}', color: Colors.white70, unit: unit),
                  ],
                ),
                SizedBox(height: unit * 3),
                Container(height: 1, color: Colors.white.withOpacity(0.05)),
                SizedBox(height: unit * 3),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _MacroIndicator(label: 'P', value: metrics.proteinToday, target: metrics.targetProtein, color: const Color(0xFF10B981), unit: unit),
                    _MacroIndicator(label: 'F', value: metrics.fatsToday, target: 40.0, color: gold, unit: unit),
                    _MacroIndicator(label: 'C', value: metrics.carbsToday, target: 150.0, color: Colors.blueAccent, unit: unit),
                    _MacroIndicator(label: 'W', value: metrics.waterToday, target: metrics.targetWater, color: Colors.cyanAccent, isWater: true, unit: unit),
                  ],
                ),
              ],
            ),
          ),

          // 2. ПОЛОСКА ИСТОРИИ (НЕДЕЛЯ) - РЕЗИНОВАЯ
          Padding(
            padding: EdgeInsets.symmetric(horizontal: unit * 4),
            child: Container(
              height: unit * 14, 
              decoration: BoxDecoration(
                color: const Color(0xFF001108),
                borderRadius: BorderRadius.circular(unit * 2),
                border: Border.all(color: Colors.white.withOpacity(0.05)),
              ),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 7,
                reverse: true,
                padding: EdgeInsets.symmetric(horizontal: unit * 2),
                itemBuilder: (context, index) {
                  DateTime date = DateTime.now().subtract(Duration(days: index));
                  String dayLabel = ["MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN"][date.weekday - 1];
                  bool isToday = index == 0;
                  
                  return Container(
                    width: unit * 12,
                    margin: EdgeInsets.symmetric(horizontal: unit * 1, vertical: unit * 1.5),
                    decoration: BoxDecoration(
                      color: isToday ? gold.withOpacity(0.1) : Colors.transparent,
                      borderRadius: BorderRadius.circular(unit * 2),
                      border: isToday ? Border.all(color: gold.withOpacity(0.4)) : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(dayLabel, style: TextStyle(color: isToday ? gold : Colors.white38, fontSize: unit * 2.2, fontWeight: FontWeight.bold)),
                        Text(isToday ? "${metrics.eatenToday.toInt()}" : "0", 
                             style: TextStyle(color: Colors.white70, fontSize: unit * 2.2)),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),

          SizedBox(height: unit * 2),
// --- ВОТ ОН: НАШ КРАСИВЫЙ СКАНЕР (ЗОЛОТАЯ РАМКА) ---
          // --- ОБНОВЛЕННАЯ ПАНЕЛЬ: СКАНЕР + АРХИВ ---
Padding(
  padding: EdgeInsets.symmetric(horizontal: unit * 4),
  child: Row(
    children: [
      // 1. КНОПКА: БИО-СКАНЕР
      Expanded(
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const BioMatchScreen(mealName: 'Scanner'), 
              ),
            );
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: unit * 2.5),
            decoration: BoxDecoration(
              color: const Color(0xFF001A10),
              borderRadius: BorderRadius.circular(unit * 2),
              border: Border.all(color: gold.withOpacity(0.5), width: 1.2),
              boxShadow: [BoxShadow(color: gold.withOpacity(0.05), blurRadius: 5)],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.qr_code_scanner, color: gold, size: unit * 5),
                SizedBox(width: unit * 2),
                Text("SCANNER", 
                  style: TextStyle(color: gold, fontWeight: FontWeight.bold, letterSpacing: 1, fontSize: unit * 3)),
              ],
            ),
          ),
        ),
      ),
      
      SizedBox(width: unit * 3), // Промежуток между кнопками

      // 2. КНОПКА: АРХИВ ЕДЫ (Тот самый прямой вход!)
      Expanded(
        child: GestureDetector(
          onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const FoodCategoryScreen(mealName: 'ARCHIVE'), 
    ),
  );
},
          child: Container(
            padding: EdgeInsets.symmetric(vertical: unit * 2.5),
            decoration: BoxDecoration(
              color: const Color(0xFF001A10),
              borderRadius: BorderRadius.circular(unit * 2),
              border: Border.all(color: gold.withOpacity(0.5), width: 1.2),
              boxShadow: [BoxShadow(color: gold.withOpacity(0.05), blurRadius: 5)],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.menu_book, color: gold, size: unit * 5),
                SizedBox(width: unit * 2),
                Text("ARCHIVE", 
                  style: TextStyle(color: gold, fontWeight: FontWeight.bold, letterSpacing: 1, fontSize: unit * 3)),
              ],
            ),
          ),
        ),
      ),
    ],
  ),
),
          SizedBox(height: unit * 2),
          // 3. ПАНЕЛИ ПРИЕМА ПИЩИ
          Expanded(
  child: ListView(
    padding: EdgeInsets.symmetric(horizontal: unit * 4),
    children: [
      // ЗАВТРАК
      _buildMealCard(
        unit: unit,
        title: 'Breakfast',
        subTitle: 'Morning fuel',
        icon: Icons.wb_sunny_outlined,
        kcal: '${metrics.breakfastKcal.toInt()}',
        p: metrics.breakfastP, f: metrics.breakfastF, c: metrics.breakfastC,
        onTap: () => Navigator.push(context, MaterialPageRoute(
          builder: (context) => const MealDetailScreen(mealName: 'Breakfast'))),
      ),
      // СНЭК 1
      _buildMealCard(
        unit: unit,
        title: 'Snack 1',
        subTitle: 'Biological recharge',
        icon: Icons.fastfood_outlined,
        kcal: '${metrics.snack1Kcal.toInt()}',
        p: metrics.snack1P, f: metrics.snack1F, c: metrics.snack1C,
        onTap: () => Navigator.push(context, MaterialPageRoute(
          builder: (context) => const MealDetailScreen(mealName: 'Snack 1'))),
      ),
      // ОБЕД (ЛАНЧ)
      _buildMealCard(
        unit: unit,
        title: 'Lunch',
        subTitle: 'Main energy',
        icon: Icons.restaurant,
        kcal: '${metrics.lunchKcal.toInt()}',
        p: metrics.lunchP, f: metrics.lunchF, c: metrics.lunchC,
        onTap: () => Navigator.push(context, MaterialPageRoute(
          builder: (context) => const MealDetailScreen(mealName: 'Lunch'))),
      ),
      // СНЭК 2
      _buildMealCard(
        unit: unit,
        title: 'Snack 2',
        subTitle: 'Metabolic support',
        icon: Icons.coffee,
        kcal: '${metrics.snack2Kcal.toInt()}',
        p: metrics.snack2P, f: metrics.snack2F, c: metrics.snack2C,
        onTap: () => Navigator.push(context, MaterialPageRoute(
          builder: (context) => const MealDetailScreen(mealName: 'Snack 2'))),
      ),
      // УЖИН
      _buildMealCard(
        unit: unit,
        title: 'Dinner',
        subTitle: 'Recovery complex',
        icon: Icons.nights_stay_outlined,
        kcal: '${metrics.dinnerKcal.toInt()}',
        p: metrics.dinnerP, f: metrics.dinnerF, c: metrics.dinnerC,
        onTap: () => Navigator.push(context, MaterialPageRoute(
          builder: (context) => const MealDetailScreen(mealName: 'Dinner'))),
      ),
      SizedBox(height: unit * 8),
    ],
  ),
),
        ],
      ),
    );
  }

  Widget _buildMealCard({
    required double unit,
    required String title, 
    required String subTitle, 
    required IconData icon, 
    required String kcal, 
    double p = 0, double f = 0, double c = 0, 
    required VoidCallback onTap
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: unit * 3),
        padding: EdgeInsets.all(unit * 4),
        decoration: BoxDecoration(
          color: const Color(0xFF001108), 
          borderRadius: BorderRadius.circular(unit * 2),
          border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.3), width: 0.8),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFFD4AF37), size: unit * 6),
            SizedBox(width: unit * 5),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title.toUpperCase(), style: TextStyle(color: const Color(0xFFD4AF37), fontWeight: FontWeight.w900, letterSpacing: 2, fontSize: unit * 3.2)),
                  Text(subTitle, style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: unit * 2.5)),
                  SizedBox(height: unit * 1),
                  Row(
                    children: [
                      _smallMacro('P', p, const Color(0xFF10B981), unit),
                      SizedBox(width: unit * 2),
                      _smallMacro('F', f, const Color(0xFFD4AF37), unit),
                      SizedBox(width: unit * 2),
                      _smallMacro('C', c, Colors.blueAccent, unit),
                    ],
                  ),
                ],
              ),
            ),
            Text(kcal, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w200, fontSize: unit * 5)),
            SizedBox(width: unit * 1),
            Text('kcal', style: TextStyle(color: Colors.white38, fontSize: unit * 2.5)),
            SizedBox(width: unit * 3),
            Icon(Icons.arrow_forward_ios, color: const Color(0xFFD4AF37), size: unit * 3),
          ],
        ),
      ),
    );
  }

  Widget _smallMacro(String label, double val, Color color, double unit) {
    return Text(
      '$label: ${val.toInt()}g',
      style: TextStyle(color: color.withOpacity(0.8), fontSize: unit * 2.2, fontWeight: FontWeight.bold),
    );
  }
}

// ВИДЖЕТЫ-ПОМОЩНИКИ (ВНЕ КЛАССА)
class _StatColumn extends StatelessWidget {
  final String title; final String value; final Color color; final bool isMain; final double unit;
  const _StatColumn({required this.title, required this.value, required this.color, this.isMain = false, required this.unit});
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(title, style: TextStyle(color: Colors.grey, fontSize: unit * 2.2, letterSpacing: 1.2)),
      SizedBox(height: unit * 1),
      Text(value, style: TextStyle(color: color, fontSize: isMain ? unit * 7 : unit * 5.5, fontWeight: FontWeight.w200, letterSpacing: 1.5)),
      Text('kcal', style: TextStyle(color: color.withOpacity(0.5), fontSize: unit * 2.2)),
    ]);
  }
}

class _MacroIndicator extends StatelessWidget {
  final String label; final double value; final double target; final Color color; final bool isWater; final double unit;
  const _MacroIndicator({required this.label, required this.value, required this.target, required this.color, this.isWater = false, required this.unit});
  @override
  Widget build(BuildContext context) {
    double progress = (target > 0) ? (value / target).clamp(0.0, 1.0) : 0.0;
    return Column(children: [
      Text(label, style: TextStyle(color: color, fontSize: unit * 3.5, fontWeight: FontWeight.bold)),
      SizedBox(height: unit * 1.2),
      Stack(children: [
        Container(width: unit * 10, height: unit * 1, decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(unit))),
        Container(width: unit * 10 * progress, height: unit * 1, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(unit), boxShadow: [BoxShadow(color: color.withOpacity(0.5), blurRadius: 4)])),
      ]),
      SizedBox(height: unit * 1),
      Text(isWater ? '${value.toStringAsFixed(1)}L' : '${value.toInt()}g', style: TextStyle(color: Colors.white, fontSize: unit * 2.5)),
    ]);
  }
}