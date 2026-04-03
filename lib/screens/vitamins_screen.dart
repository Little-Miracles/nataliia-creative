import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_body_life/providers/metrics_provider.dart';

// 🔹 Модель данных
class VitaminItem {
  final String name;
  final String desc;
  final String category;
  final String unit;       
  final int kcalPerUnit;   

  VitaminItem({
    required this.name,
    required this.desc,
    required this.category,
    required this.unit,
    required this.kcalPerUnit,
  });
}

class VitaminsScreen extends StatefulWidget {
  final String mealName; // <--- Добавь это
  final File? imageFile; // 1. ДОБАВЬ ЭТУ СТРОКУ
  const VitaminsScreen({super.key, required this.mealName, this.imageFile});

  @override
  State<VitaminsScreen> createState() => _VitaminsScreenState();
}

class _VitaminsScreenState extends State<VitaminsScreen> {
  final Color copper = const Color(0xFF8B5E3C);
  final Color cream = const Color(0xFFEDE6D6); // <--- ДОБАВЬ ЭТУ СТРОЧКУ СЮДА

  // ✅ Категории
  final List<String> categories = [
    'ALL',
    'VITAMINS',
    'MINERALS',
    'OMEGA',
    'SUPPLEMENTS'
  ];

  String selectedCat = 'ALL';

  // 🔥 ИСПРАВЛЕННАЯ БАЗА ДАННЫХ
  final List<VitaminItem> vitaminDatabase = [
    // VITAMINS
    VitaminItem(name: 'Vitamin C', desc: 'immunity, antioxidant', category: 'VITAMINS', unit: 'tablet', kcalPerUnit: 0),
    VitaminItem(name: 'Vitamin D3', desc: 'bones, mood, immunity', category: 'VITAMINS', unit: 'capsule', kcalPerUnit: 0),
    VitaminItem(name: 'Vitamin B Complex', desc: 'energy, nervous system', category: 'VITAMINS', unit: 'capsule', kcalPerUnit: 0),
    VitaminItem(name: 'Vitamin A', desc: 'vision, skin', category: 'VITAMINS', unit: 'capsule', kcalPerUnit: 0),
    VitaminItem(name: 'Vitamin E', desc: 'skin, antioxidant', category: 'VITAMINS', unit: 'capsule', kcalPerUnit: 0),

    // MINERALS
    VitaminItem(name: 'Magnesium B6', desc: 'sleep, stress, muscles', category: 'MINERALS', unit: 'tablet', kcalPerUnit: 0),
    VitaminItem(name: 'Zinc', desc: 'immunity, skin', category: 'MINERALS', unit: 'tablet', kcalPerUnit: 0),
    VitaminItem(name: 'Iron', desc: 'blood, energy', category: 'MINERALS', unit: 'tablet', kcalPerUnit: 0),
    VitaminItem(name: 'Calcium', desc: 'bones, teeth', category: 'MINERALS', unit: 'tablet', kcalPerUnit: 0),

    // OMEGA
    VitaminItem(name: 'Omega-3', desc: 'heart, brain, skin', category: 'OMEGA', unit: 'capsule', kcalPerUnit: 9),
    VitaminItem(name: 'Fish Oil', desc: 'omega fats, joints', category: 'OMEGA', unit: 'capsule', kcalPerUnit: 9),

    // SUPPLEMENTS
    VitaminItem(name: 'Multivitamin', desc: 'daily support', category: 'SUPPLEMENTS', unit: 'tablet', kcalPerUnit: 0),
    VitaminItem(name: 'Collagen', desc: 'skin, joints, hair', category: 'SUPPLEMENTS', unit: 'scoop', kcalPerUnit: 40),
    VitaminItem(name: 'Protein Powder', desc: 'muscle recovery', category: 'SUPPLEMENTS', unit: 'scoop', kcalPerUnit: 120),
    VitaminItem(name: 'Probiotics', desc: 'gut health', category: 'SUPPLEMENTS', unit: 'capsule', kcalPerUnit: 0),
    VitaminItem(name: 'Melatonin', desc: 'sleep support', category: 'SUPPLEMENTS', unit: 'tablet', kcalPerUnit: 0),
  ];

IconData _getCategoryIcon(String category) {
  switch (category) {
    case 'VITAMINS':
      return Icons.health_and_safety_outlined; // Щит для витаминов
    case 'MINERALS':
      return Icons.diamond_outlined; // Алмаз для минералов
    case 'OMEGA':
      return Icons.water_drop_outlined; // Капля для Омеги
    case 'SUPPLEMENTS':
      return Icons.fitness_center_outlined; // Гантель для добавок
    default:
      return Icons.medication_liquid_outlined; // Стандартный значок
  }
}

@override
  Widget build(BuildContext context) {
    double unit = MediaQuery.of(context).size.width / 100;

    return Scaffold(
      backgroundColor: const Color(0xFF05100A),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: copper, size: unit * 5),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('VITAMINS', style: TextStyle(color: copper, fontWeight: FontWeight.bold, letterSpacing: 2, fontSize: unit * 4.5)),
        backgroundColor: Colors.transparent, elevation: 0, centerTitle: true,
      ),
      body: Column(
        children: [
          _buildFilterPanel(unit),
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(unit * 4),
              children: vitaminDatabase
                  .where((item) => selectedCat == 'ALL' || item.category == selectedCat)
                  .map((item) => _buildTile(item, unit))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterPanel(double unit) {
    return Container(
      height: unit * 10,
      margin: EdgeInsets.symmetric(vertical: unit * 2),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: unit * 4),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final cat = categories[index];
          final selected = cat == selectedCat;
          return GestureDetector(
            onTap: () => setState(() => selectedCat = cat),
            child: Container(
              margin: EdgeInsets.only(right: unit * 2.5),
              padding: EdgeInsets.symmetric(horizontal: unit * 4),
              decoration: BoxDecoration(
                color: selected ? copper : Colors.transparent,
                borderRadius: BorderRadius.circular(unit * 5),
                border: Border.all(color: copper.withOpacity(0.5)),
              ),
              alignment: Alignment.center,
              child: Text(cat, style: TextStyle(color: selected ? Colors.black : cream, fontSize: unit * 2.5, fontWeight: FontWeight.bold)),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTile(VitaminItem item, double unit) {
    return Container(
      margin: EdgeInsets.only(bottom: unit * 3),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [copper.withOpacity(0.6), const Color(0xFF1B140E)],
          begin: Alignment.topLeft, end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(unit * 3),
        border: Border.all(color: copper.withOpacity(0.3)),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: unit * 4, vertical: unit * 1),
        leading: Container(
          padding: EdgeInsets.all(unit * 2),
          decoration: BoxDecoration(color: Colors.black.withOpacity(0.2), shape: BoxShape.circle),
          child: Icon(_getCategoryIcon(item.category), color: cream, size: unit * 6),
        ),
        title: Text(item.name.toUpperCase(), 
            style: TextStyle(color: cream, fontWeight: FontWeight.w900, fontSize: unit * 3.2, letterSpacing: 0.5)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item.desc, style: TextStyle(color: cream.withOpacity(0.7), fontSize: unit * 2.8)),
            SizedBox(height: unit * 1),
            Text("DAILY DOSE • AFTER MEAL", 
                style: TextStyle(color: copper, fontSize: unit * 2.2, fontWeight: FontWeight.bold, letterSpacing: 1)),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('${item.kcalPerUnit}', style: TextStyle(color: cream, fontWeight: FontWeight.bold, fontSize: unit * 3.5)),
                Text("KCAL", style: TextStyle(color: cream.withOpacity(0.5), fontSize: unit * 2)),
              ],
            ),
            SizedBox(width: unit * 2),
            IconButton(
              icon: Icon(Icons.add_circle_outline, color: cream, size: unit * 7),
              onPressed: () => _showVitaminDialog(item, unit),
            ),
          ],
        ),
        onTap: () => _showVitaminDialog(item, unit),
      ),
    );
  }

  void _showVitaminDialog(VitaminItem item, double unit) {
    final TextEditingController controller = TextEditingController(text: '1');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF05100A),
        shape: RoundedRectangleBorder(side: BorderSide(color: copper), borderRadius: BorderRadius.circular(15)),
        title: Text(item.name.toUpperCase(), style: TextStyle(color: copper, fontSize: unit * 4)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Quantity (${item.unit}s):', style: TextStyle(color: Colors.white70, fontSize: unit * 3)),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              style: TextStyle(color: copper, fontWeight: FontWeight.bold, fontSize: unit * 4.5),
              decoration: InputDecoration(enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: copper))),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCEL', style: TextStyle(color: Colors.white54))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: copper),
            onPressed: () {
              int count = int.tryParse(controller.text) ?? 1;
              double addedKcal = (item.kcalPerUnit * count).toDouble();

              // 🔥 ТЕПЕРЬ ОТПРАВЛЯЕМ В БЛОКНОТ
              Provider.of<MetricsProvider>(context, listen: false).addMealData(
                mealName: widget.mealName,
                foodName: "${item.name} ($count ${item.unit})",
                kcal: addedKcal,
                p: 0, f: 0, c: 0, // БЖУ у витаминов обычно пренебрежимо мало
              );

              Navigator.pop(context); // Закрыть окно
              Navigator.pop(context); // Закрыть Витамины
              Navigator.pop(context); // Закрыть Категории
            },
            child: const Text('ADD', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}