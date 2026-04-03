import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/metrics_provider.dart';
import 'food_category_screen.dart'; // Твои вкладки (Супы, Снеки и т.д.)

class MealDetailScreen extends StatelessWidget {
  final String mealName;
  const MealDetailScreen({super.key, required this.mealName});

  @override
  Widget build(BuildContext context) {
    final metrics = Provider.of<MetricsProvider>(context);
    
    // Выбираем список продуктов для конкретного приема пищи
    List<FoodRecord> records = [];
    if (mealName == 'Breakfast') records = metrics.breakfastList;
    else if (mealName == 'Snack 1') records = metrics.snack1List;
    else if (mealName == 'Lunch') records = metrics.lunchList;
    else if (mealName == 'Snack 2') records = metrics.snack2List;
    else if (mealName == 'Dinner') records = metrics.dinnerList;

// 1. Считаем итоговые калории завтрака прямо здесь
  double totalMealKcal = records.fold(0, (sum, item) => sum + item.kcal);

    return Scaffold(
      backgroundColor: const Color(0xFF05100A), // Твой темный фон
      appBar: AppBar(
        title: Text(mealName.toUpperCase(), style: const TextStyle(color: Color(0xFFD4AF37))),
        backgroundColor: Colors.transparent,
        actions: [
          // Кнопка ПЛЮСИК для перехода к вкладкам еды
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: Color(0xFFD4AF37), size: 30),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => FoodCategoryScreen(mealName: mealName)
              ));
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // ШАПКА ТАБЛИЦЫ (Названия колонок)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Row(
              children: [
                const Expanded(flex: 3, child: Text("PRODUCT", style: TextStyle(color: Colors.white54, fontSize: 12))),
                const Expanded(child: Text("KCAL", style: TextStyle(color: Colors.white54, fontSize: 12))),
                const Expanded(child: Text("P", style: TextStyle(color: Colors.white54, fontSize: 12))),
                const Expanded(child: Text("F", style: TextStyle(color: Colors.white54, fontSize: 12))),
                const Expanded(child: Text("C", style: TextStyle(color: Colors.white54, fontSize: 12))),
                const SizedBox(width: 40), // Место под корзину
              ],
            ),
          ),
          const Divider(color: Colors.white12),

          // СПИСОК ПРОДУКТОВ (Наш блокнот)
          Expanded(
            child: records.isEmpty 
              ? const Center(child: Text("Empty list. Press + to add food", style: TextStyle(color: Colors.white24)))
              : ListView.builder(
                  itemCount: records.length,
                  itemBuilder: (context, index) {
                    final item = records[index];
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                      title: Row(
                        children: [
                          Expanded(flex: 3, child: Text(item.name, style: const TextStyle(color: Colors.white, fontSize: 14))),
                          // Внутри Row, где были нули:
Expanded(child: Text("${item.kcal.toInt()}", style: const TextStyle(color: Color(0xFFD4AF37)))),
Expanded(child: Text("${item.p.toStringAsFixed(1)}", style: const TextStyle(color: Colors.white70, fontSize: 12))), // БЕЛКИ
Expanded(child: Text("${item.f.toStringAsFixed(1)}", style: const TextStyle(color: Colors.white70, fontSize: 12))), // ЖИРЫ
Expanded(child: Text("${item.c.toStringAsFixed(1)}", style: const TextStyle(color: Colors.white70, fontSize: 12))), // УГЛЕВОДЫ
                        ],
                      ),
                      // КОРЗИНА УДАЛЕНИЯ
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                        onPressed: () {
  // Вызываем удаление по номеру строки (index)
  metrics.removeFoodFromMeal(mealName, index);
},
                      ),
                    );
                  },
                ),
          ),

          // ИТОГОВАЯ ПАНЕЛЬ
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.3)),
            ),
            child: Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("TOTAL MEAL:", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          Text("${totalMealKcal.toInt()} kcal", // ТЕПЕРЬ ЦИФРА ЖИВАЯ
               style: const TextStyle(color: Color(0xFFD4AF37), fontSize: 18)),
        ],
      ),
                const SizedBox(height: 20),
                // КНОПКА СОХРАНИТЬ
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD4AF37)),
                    onPressed: () {
                      // Тут логика отправки данных в главный монитор и выход
                      Navigator.pop(context);
                    },
                    child: const Text("SAVE TO DIARY", style: TextStyle(color: Colors.black)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}