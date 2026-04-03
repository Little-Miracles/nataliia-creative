import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_body_life/data/global_data.dart';
import 'package:smart_body_life/providers/metrics_provider.dart';
import 'package:smart_body_life/screens/functional_screen.dart';
import 'package:smart_body_life/screens/salads_screen.dart';

class SnackItem {
  final String name;
  final String desc;
  final String category;
  final String icon; 
  final String? imageUrl; // <--- ВОТ ЭТО ДОЛЖНО БЫТЬ ТУТ!
  final double kcal100g;
  final double proteins;
  final double fats;
  final double carbs;

  SnackItem({
    required this.name,
    required this.desc,
    required this.category,
    required this.icon,
    this.imageUrl, // <--- И ТУТ!
    required this.kcal100g,
    required this.proteins,
    required this.fats,
    required this.carbs,
  });
}

// ТВОЯ КОФЕЙНО-ЗОЛОТАЯ ПАЛИТРА
const Color musterGold = Color(0xFFC0A060); 
const Color deepCoffee = Color(0xFF1B140E); 

class SnacksScreen extends StatefulWidget {
  final String mealName; 
  final File? imageFile; 
  const SnacksScreen({super.key, required this.mealName, this.imageFile});

  @override
  State<SnacksScreen> createState() => _SnacksScreenState();
}

class _SnacksScreenState extends State<SnacksScreen> {
  // 🟢 ИКОНКИ БЕЗ БРЕНДОВ (Только геометрия и еда)
  final Map<String, IconData> categoryIcons = {
    'ALL': Icons.grid_view_rounded,
    'FRUITS': Icons.circle, // Теперь это цельное "яблоко" или "апельсин"
    'BERRIES': Icons.grain_rounded,
    'CITRUS': Icons.bedtime_off_rounded, // Похоже на дольку
    'EXOTIC': Icons.flare_rounded, // Как яркий тропический фрукт
    'VEGGIES': Icons.eco, // Закрашенный листик
    'GREENS': Icons.spa, // Закрашенный лотос
    'NUTS': Icons.album_rounded, // Плотный орешек
    'DAIRY': Icons.opacity, // Плотная капля молока
    'SWEETS': Icons.bakery_dining, // А вот это уже настоящий круассан!
    'GRAINS': Icons.bar_chart_rounded, // Похоже на колосья разной высоты
  };

  final List<String> categories = [
    'ALL', 'FRUITS', 'BERRIES', 'CITRUS', 'EXOTIC', 'VEGGIES', 'GREENS', 'NUTS', 'DAIRY', 'SWEETS', 'GRAINS'
  ];
  
  String selectedCat = 'ALL';
  

  final List<SnackItem> snackDatabase = [
    // 🍎 FRUITS
    SnackItem(name: 'Apple', icon: '🍎', desc: 'apple, fresh, sweet, fiber', category: 'FRUITS', kcal100g: 52, proteins: 0.3, fats: 0.2, carbs: 14),
    SnackItem(name: 'Pear', icon: '🍐', desc: 'pear, juicy, sweet, fiber', category: 'FRUITS', kcal100g: 57, proteins: 0.4, fats: 0.1, carbs: 15),
    SnackItem(name: 'Peach', icon: '🍑', desc: 'peach, soft, juicy, vitamins', category: 'FRUITS', kcal100g: 39, proteins: 0.9, fats: 0.3, carbs: 10),
    SnackItem(name: 'Plum', icon: '🫐', desc: 'plum, sweet, fiber, vitamins', category: 'FRUITS', kcal100g: 46, proteins: 0.7, fats: 0.3, carbs: 11),
    SnackItem(name: 'Apricot', icon: '🟠', desc: 'apricot, soft, sweet, vitamins', category: 'FRUITS', kcal100g: 48, proteins: 1.4, fats: 0.4, carbs: 11),
    SnackItem(name: 'Banana', icon: '🍌', desc: 'banana, sweet, potassium, energy', category: 'FRUITS', kcal100g: 89, proteins: 1.1, fats: 0.3, carbs: 23),
    SnackItem(name: 'Grapes', icon: '🍇', desc: 'grapes, sweet, antioxidants', category: 'FRUITS', kcal100g: 69, proteins: 0.7, fats: 0.2, carbs: 18),
    SnackItem(name: 'Apple Slices', icon: '🍱', desc: 'apple, sliced, fresh snack', category: 'FRUITS', kcal100g: 52, proteins: 0.3, fats: 0.2, carbs: 14),

    // 🍓 BERRIES
    SnackItem(name: 'Strawberries', icon: '🍓', desc: 'strawberry, fresh, vitamin c', category: 'BERRIES', kcal100g: 32, proteins: 0.7, fats: 0.3, carbs: 8),
    SnackItem(name: 'Blueberries', icon: '🫐', desc: 'blueberry, antioxidants, sweet', category: 'BERRIES', kcal100g: 57, proteins: 0.7, fats: 0.3, carbs: 14),
    SnackItem(name: 'Raspberries', icon: '🍒', desc: 'raspberry, fiber, tart, fresh', category: 'BERRIES', kcal100g: 52, proteins: 1.2, fats: 0.7, carbs: 12),
    SnackItem(name: 'Blackberries', icon: '🍇', desc: 'blackberry, juicy, antioxidants', category: 'BERRIES', kcal100g: 43, proteins: 1.4, fats: 0.5, carbs: 10),
    SnackItem(name: 'Cranberries', icon: '🔴', desc: 'cranberry, tart, vitamins', category: 'BERRIES', kcal100g: 46, proteins: 0.4, fats: 0.1, carbs: 12),
    SnackItem(name: 'Gooseberries', icon: '🟢', desc: 'gooseberry, sour, fiber', category: 'BERRIES', kcal100g: 44, proteins: 0.9, fats: 0.6, carbs: 10),

    // 🍊 CITRUS
    SnackItem(name: 'Orange', icon: '🍊', desc: 'orange, juicy, vitamin c', category: 'CITRUS', kcal100g: 47, proteins: 0.9, fats: 0.1, carbs: 12),
    SnackItem(name: 'Mandarin', icon: '🍊', desc: 'mandarin, sweet, easy peel', category: 'CITRUS', kcal100g: 53, proteins: 0.8, fats: 0.3, carbs: 13),
    SnackItem(name: 'Grapefruit', icon: '🍋', desc: 'grapefruit, bitter, vitamins', category: 'CITRUS', kcal100g: 42, proteins: 0.8, fats: 0.1, carbs: 11),
    SnackItem(name: 'Lemon', icon: '🍋', desc: 'lemon, sour, vitamin c', category: 'CITRUS', kcal100g: 29, proteins: 1.1, fats: 0.3, carbs: 9),
    SnackItem(name: 'Lime', icon: '🍈', desc: 'lime, sour, fresh, vitamins', category: 'CITRUS', kcal100g: 30, proteins: 0.7, fats: 0.2, carbs: 10),

    // 🥑 EXOTIC
    SnackItem(name: 'Avocado', icon: '🥑', desc: 'avocado, healthy fats, fiber', category: 'EXOTIC', kcal100g: 160, proteins: 2.0, fats: 15.0, carbs: 9),
    SnackItem(name: 'Mango', icon: '🥭', desc: 'mango, sweet, juicy, vitamins', category: 'EXOTIC', kcal100g: 60, proteins: 0.8, fats: 0.4, carbs: 15),
    SnackItem(name: 'Pineapple', icon: '🍍', desc: 'pineapple, juicy, tropical', category: 'EXOTIC', kcal100g: 50, proteins: 0.5, fats: 0.1, carbs: 13),
    SnackItem(name: 'Kiwi', icon: '🥝', desc: 'kiwi, tangy, vitamin c', category: 'EXOTIC', kcal100g: 61, proteins: 1.1, fats: 0.5, carbs: 15),
    SnackItem(name: 'Papaya', icon: '🍈', desc: 'papaya, soft, tropical, sweet', category: 'EXOTIC', kcal100g: 43, proteins: 0.5, fats: 0.3, carbs: 11),

    // 🥜 NUTS
    SnackItem(name: 'Almonds', icon: '🥜', desc: 'almonds, raw, protein', category: 'NUTS', kcal100g: 579, proteins: 21, fats: 49, carbs: 21),
    SnackItem(name: 'Walnuts', icon: '🧠', desc: 'walnuts, omega fats, protein', category: 'NUTS', kcal100g: 654, proteins: 15, fats: 65, carbs: 14),
    SnackItem(name: 'Cashews', icon: '🥜', desc: 'cashews, creamy, protein', category: 'NUTS', kcal100g: 553, proteins: 18, fats: 44, carbs: 30),
    SnackItem(name: 'Hazelnuts', icon: '🌰', desc: 'hazelnuts, crunchy, fats', category: 'NUTS', kcal100g: 628, proteins: 15, fats: 61, carbs: 17),
    SnackItem(name: 'Pistachios', icon: '🟢', desc: 'pistachios, fiber, protein', category: 'NUTS', kcal100g: 562, proteins: 20, fats: 45, carbs: 28),
    SnackItem(name: 'Peanuts', icon: '🥜', desc: 'peanuts, protein, fats, energy', category: 'NUTS', kcal100g: 567, proteins: 26, fats: 49, carbs: 16),

    // 🥕 VEGGIES
    SnackItem(name: 'Carrot', icon: '🥕', desc: 'carrot, crunchy, beta carotene', category: 'VEGGIES', kcal100g: 41, proteins: 0.9, fats: 0.2, carbs: 10),
    SnackItem(name: 'Cucumber', icon: '🥒', desc: 'cucumber, fresh, low calorie', category: 'VEGGIES', kcal100g: 15, proteins: 0.7, fats: 0.1, carbs: 3.5),
    SnackItem(name: 'Tomato', icon: '🍅', desc: 'tomato, juicy, vitamins', category: 'VEGGIES', kcal100g: 18, proteins: 0.9, fats: 0.2, carbs: 4),
    SnackItem(name: 'Bell Pepper', icon: '🫑', desc: 'pepper, crunchy, vitamin c', category: 'VEGGIES', kcal100g: 31, proteins: 1.0, fats: 0.3, carbs: 6),
    SnackItem(name: 'Celery', icon: '🥬', desc: 'celery, crunchy, low calorie', category: 'VEGGIES', kcal100g: 16, proteins: 0.7, fats: 0.2, carbs: 3),

    // 🥬 GREENS
    SnackItem(name: 'Lettuce', icon: '🥬', desc: 'lettuce, fresh, light, fiber', category: 'GREENS', kcal100g: 15, proteins: 1.4, fats: 0.2, carbs: 2.9),
    SnackItem(name: 'Arugula', icon: '🌱', desc: 'arugula, spicy, greens, vitamins', category: 'GREENS', kcal100g: 25, proteins: 2.6, fats: 0.7, carbs: 3.7),
    SnackItem(name: 'Spinach', icon: '🍃', desc: 'spinach, iron, greens, vitamins', category: 'GREENS', kcal100g: 23, proteins: 2.9, fats: 0.4, carbs: 3.6),
    SnackItem(name: 'Iceberg Lettuce', icon: '🥗', desc: 'lettuce, crispy, fresh', category: 'GREENS', kcal100g: 14, proteins: 0.9, fats: 0.1, carbs: 3),
    SnackItem(name: 'Kale', icon: '🥬', desc: 'kale, fiber, vitamins, greens', category: 'GREENS', kcal100g: 49, proteins: 4.3, fats: 0.9, carbs: 9),

    // 🧀 DAIRY
    SnackItem(name: 'Milk', icon: '🥛', desc: 'milk, calcium, protein, vitamins', category: 'DAIRY', kcal100g: 60, proteins: 3.2, fats: 3.3, carbs: 5),
    SnackItem(name: 'Greek Yogurt', icon: '🍦', desc: 'yogurt, protein, probiotics', category: 'DAIRY', kcal100g: 59, proteins: 10, fats: 0.4, carbs: 3.6),
    SnackItem(name: 'Cottage Cheese', icon: '🍚', desc: 'cottage cheese, protein, calcium', category: 'DAIRY', kcal100g: 120, proteins: 16, fats: 5, carbs: 3),
    SnackItem(name: 'Hard Cheese', icon: '🧀', desc: 'cheese, fats, calcium, protein', category: 'DAIRY', kcal100g: 350, proteins: 25, fats: 27, carbs: 2),
    SnackItem(name: 'Kefir', icon: '🍶', desc: 'kefir, probiotics, healthy', category: 'DAIRY', kcal100g: 50, proteins: 3.0, fats: 2.0, carbs: 4),

    // 🍫 SWEETS
    SnackItem(name: 'Dark Chocolate', icon: '🍫', desc: 'cocoa, antioxidants, fats', category: 'SWEETS', kcal100g: 539, proteins: 6, fats: 35, carbs: 40),
    SnackItem(name: 'Milk Chocolate', icon: '🍫', desc: 'cocoa, milk, sugar, fats', category: 'SWEETS', kcal100g: 535, proteins: 7, fats: 30, carbs: 59),
    SnackItem(name: 'Protein Bar', icon: '🧱', desc: 'protein, chocolate, nuts', category: 'SWEETS', kcal100g: 350, proteins: 20, fats: 12, carbs: 40),
    SnackItem(name: 'Granola Bar', icon: '🌾', desc: 'oats, honey, nuts, fruit', category: 'SWEETS', kcal100g: 400, proteins: 8, fats: 15, carbs: 60),
    SnackItem(name: 'Cookies', icon: '🍪', desc: 'flour, sugar, chocolate chips', category: 'SWEETS', kcal100g: 480, proteins: 5, fats: 20, carbs: 65),
    SnackItem(name: 'Honey', icon: '🍯', desc: 'honey, natural sugar, energy', category: 'SWEETS', kcal100g: 304, proteins: 0.3, fats: 0, carbs: 82),

    // 🌾 GRAINS
    SnackItem(name: 'Rice Cakes', icon: '🍘', desc: 'rice, whole grain, light', category: 'GRAINS', kcal100g: 380, proteins: 8, fats: 3, carbs: 80),
    SnackItem(name: 'Crackers', icon: '🥨', desc: 'flour, salt, oil, crispy', category: 'GRAINS', kcal100g: 420, proteins: 9, fats: 12, carbs: 70),
    SnackItem(name: 'Toast Bread', icon: '🍞', desc: 'wheat, bread, carbs, fiber', category: 'GRAINS', kcal100g: 260, proteins: 9, fats: 3, carbs: 50),
    SnackItem(name: 'Oat Cookies', icon: '🍪', desc: 'oats, sugar, butter, fiber', category: 'GRAINS', kcal100g: 450, proteins: 6, fats: 18, carbs: 65),
    SnackItem(name: 'Granola', icon: '🥣', desc: 'oats, honey, nuts, dried fruits', category: 'GRAINS', kcal100g: 430, proteins: 10, fats: 15, carbs: 60),
  ];

 @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final List<SnackItem> filteredSnacks = selectedCat == 'ALL' 
        ? snackDatabase : snackDatabase.where((s) => s.category == selectedCat).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF05100A),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: musterGold, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('SNACKS', 
          style: TextStyle(color: musterGold, fontWeight: FontWeight.bold, letterSpacing: 2, fontSize: 16)),
        backgroundColor: Colors.transparent, elevation: 0, centerTitle: true,
      ),
      body: Column(
        children: [
          _buildFilterPanel(screenWidth),
          Expanded(
            child: filteredSnacks.isEmpty 
              ? const Center(child: Text('No items found', style: TextStyle(color: Colors.white54)))
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  itemCount: filteredSnacks.length,
                  itemBuilder: (context, index) => _buildSnackCard(filteredSnacks[index], screenWidth),
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterPanel(double screenWidth) {
    return Container(
      height: screenWidth * 0.11,
      margin: EdgeInsets.symmetric(vertical: screenWidth * 0.02),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          bool isActive = selectedCat == categories[index];
          return GestureDetector(
            onTap: () => setState(() => selectedCat = categories[index]),
            child: Container(
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(horizontal: 18),
              decoration: BoxDecoration(
                color: isActive ? musterGold : Colors.transparent,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: musterGold.withOpacity(0.5), width: 0.8),
              ),
              alignment: Alignment.center,
              child: Text(categories[index],
                style: TextStyle(color: isActive ? Colors.black : musterGold, fontWeight: FontWeight.bold, fontSize: screenWidth * 0.03)),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSnackCard(SnackItem item, double screenWidth) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF0D0805),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: musterGold.withOpacity(0.2)),
      ),
      child: InkWell(
        onTap: () {
          if (widget.mealName != 'ARCHIVE') _showPortionDialog(item, screenWidth);
        },
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Row(
            children: [
              // 1. ВОТ ТА САМАЯ ФУНКЦИЯ (Просмотр иконки/фото)
              GestureDetector(
                onTap: () {
                  // Если есть фото из базы или иконка - можно открыть (если у тебя есть FullScreenImage)
                },
                child: Container(
                  width: screenWidth * 0.12,
                  alignment: Alignment.centerLeft,
                  child: Text(item.icon, style: TextStyle(fontSize: screenWidth * 0.08)),
                ),
              ),
              const SizedBox(width: 8),

              // 2. ИНФО
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(item.name.toUpperCase(), 
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: musterGold, fontWeight: FontWeight.bold, fontSize: screenWidth * 0.032, letterSpacing: 1.1)),
                    const SizedBox(height: 2),
                    Text(item.desc, 
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.white54, fontSize: screenWidth * 0.026)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        _macro('P', item.proteins, screenWidth),
                        _macro('F', item.fats, screenWidth),
                        _macro('C', item.carbs, screenWidth),
                      ],
                    )
                  ],
                ),
              ),

              // 3. ПРАВАЯ ЧАСТЬ (Ккал + Умная кнопка)
              SizedBox(
                width: screenWidth * 0.30,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('${item.kcal100g.toInt()} kcal', 
                      style: TextStyle(color: musterGold, fontWeight: FontWeight.bold, fontSize: screenWidth * 0.032)),
                    const SizedBox(width: 8),
                    
                    widget.imageFile == null 
                    ? IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: Icon(Icons.add_circle_outline, color: musterGold, size: screenWidth * 0.075),
                        onPressed: () {
                          if (widget.mealName == 'ARCHIVE') {
                            _showArchiveInfo(context);
                          } else {
                            _showPortionDialog(item, screenWidth);
                          }
                        },
                      )
                    : GestureDetector(
                        onTap: () {
                          if (widget.mealName == 'ARCHIVE') {
                            _showArchiveInfo(context);
                          } else {
                            _showLibrarySaveDialog(FoodItem(name: item.name, desc: item.desc, category: item.category, kcal100g: item.kcal100g, proteins: item.proteins, fats: item.fats, carbs: item.carbs)); 
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: musterGold, width: 1.5),
                          ),
                          child: Icon(Icons.biotech, color: musterGold, size: screenWidth * 0.055),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _macro(String label, double val, double screenWidth) {
    return Padding(
      padding: EdgeInsets.only(right: screenWidth * 0.025),
      child: Text('$label: ${val.toStringAsFixed(0)}', 
        style: TextStyle(color: musterGold.withOpacity(0.7), fontWeight: FontWeight.bold, fontSize: screenWidth * 0.026)),
    );
  }

  void _showArchiveInfo(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("To add to Diary, please start from Breakfast/Lunch"),
        backgroundColor: Color(0xFF020326),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showPortionDialog(SnackItem item, double screenWidth) {
    final TextEditingController controller = TextEditingController(text: '30');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF05100A),
        shape: RoundedRectangleBorder(side: const BorderSide(color: musterGold), borderRadius: BorderRadius.circular(15)),
        title: Text(item.name.toUpperCase(), style: const TextStyle(color: musterGold, fontSize: 14)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Portion weight (grams):', style: TextStyle(color: Colors.white70, fontSize: 12)),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: musterGold, fontWeight: FontWeight.bold),
              decoration: const InputDecoration(enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: musterGold))),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCEL', style: TextStyle(color: Colors.white54))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: musterGold),
            onPressed: () {
              double weight = double.tryParse(controller.text) ?? 30;
              double factor = weight / 100;
              final metrics = Provider.of<MetricsProvider>(context, listen: false);
              
              metrics.addMealData(
                mealName: widget.mealName,
                foodName: item.name,
                kcal: item.kcal100g * factor,
                p: item.proteins * factor,
                f: item.fats * factor,
                c: item.carbs * factor,
                imagePath: widget.imageFile?.path,
              );

              if (widget.mealName == 'BIO-SCAN') {
                // ПРЫГАЕМ ДО ДНЕВНИКА (4 шага)
                Navigator.pop(context); Navigator.pop(context); 
                Navigator.pop(context); Navigator.pop(context); 
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Sent to Laboratory!'), backgroundColor: Colors.amber),
                );
              } else {
                // ОБЫЧНЫЙ ВЫБОР (3 шага)
                Navigator.pop(context); Navigator.pop(context); Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${item.name} added!'), backgroundColor: musterGold)
                );
              }
            },
            child: const Text('ADD', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showLibrarySaveDialog(FoodItem soup) {
  // Мы не будем мучить пользователя вводом веса, 
  // так как в библиотеку мы сохраняем эталон (на 100г)
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: const Color(0xFF05100A),
      shape: RoundedRectangleBorder(side: const BorderSide(color: musterGold), borderRadius: BorderRadius.circular(15)),
      title: Text("SAVE TO LIBRARY?", style: const TextStyle(color: musterGold, fontSize: 14)),
      content: Text("Do you want to save ${soup.name} with your photo to your personal library?", 
        style: const TextStyle(color: Colors.white70, fontSize: 12)),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context), 
          child: const Text('CANCEL', style: TextStyle(color: Colors.white54))
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: musterGold),
          onPressed: () {
  // 1. САМОЕ ГЛАВНОЕ: Кладём продукт в общую библиотеку
  globalLibrary.add(
    LibraryProduct(
      name: soup.name,
      calories: soup.kcal100g.toInt().toString(), // Сохраняем как эталон (на 100г)
      proteins: soup.proteins.toString(),
      fats: soup.fats.toString(),
      carbs: soup.carbs.toString(),
      imagePath: widget.imageFile?.path, // Твое фото из галереи!
      desc: soup.desc, // Состав: beef, beets...
    ),
  );

  // 2. Закрываем диалог
  Navigator.pop(context);

  // 3. ПЕРЕПРЫГИВАЕМ в саму Библиотеку, чтобы увидеть результат
  /*Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const FunctionalScreen(mealName: 'MY LIBRARY'),
    ),
  );*/
  // 3. ПЕРЕПРЫГИВАЕМ в саму Библиотеку, заменяя экран категорий
  Navigator.pushReplacement( // Используем Replacement, чтобы не копить окна
    context,
    MaterialPageRoute(
      builder: (context) => FunctionalScreen(mealName: widget.mealName),
    ),
  );

  // 4. Показываем радостное сообщение (зеленое снизу)
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('${soup.name} saved to My Library!'),
      backgroundColor: Colors.green[800],
    ),
  );
},
          child: const Text('SAVE', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        ),
      ],
    ),
  );
}
}