import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Добавили для связи с монитором
import 'package:smart_body_life/data/global_data.dart'; 
import 'package:smart_body_life/providers/metrics_provider.dart'; // Добавили провайдер

class FunctionalScreen extends StatefulWidget {
  final String mealName; // <--- Добавь это
  final File? imageFile; // 1. ДОБАВЬ ЭТУ СТРОКУ
  const FunctionalScreen({super.key, required this.mealName, this.imageFile});

  @override
  State<FunctionalScreen> createState() => _FunctionalScreenState();
}

class _FunctionalScreenState extends State<FunctionalScreen> {
  final Color accent = const Color(0xFF4BCAAD); 
  final Color shadow = const Color(0xFF033E40); 
  final Color gold = const Color(0xFFC0A060); // Добавили твой золотой

  @override
  Widget build(BuildContext context) {
   double unit = MediaQuery.of(context).size.width / 100; 
    return Scaffold(
      backgroundColor: const Color(0xFF05100A), 
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: accent, size: unit * 5), // Сделали размер иконки резиновым
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'MY AUTHORS DISHES', 
          style: TextStyle(color: accent, fontWeight: FontWeight.bold, letterSpacing: 2)
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: globalLibrary.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.biotech_outlined, color: accent.withAlpha(50), size: 80),
                  const SizedBox(height: 20),
                  Text(
                    "Your library is empty.\nScan or add products to BIO-FOOD DESIGNER to see them here.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: const Color(0xFFEDE6D6).withAlpha(100), fontSize: unit * 4, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(15),
              itemCount: globalLibrary.length,
              itemBuilder: (context, index) {
                final item = globalLibrary[index];
                
                return Dismissible(
                  key: Key(item.name + index.toString()),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.redAccent.withAlpha(200),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(Icons.delete_sweep, color: Colors.white, size: 28),
                  ),
                  onDismissed: (direction) {
                    setState(() {
                      globalLibrary.removeAt(index);
                    });
                  },
                  child: _buildLibraryTile(item, index),
                );
              },
            ),
    );
  }

  Widget _buildLibraryTile(LibraryProduct item, int index) {
    const Color cream = Color(0xFFEDE6D6);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [accent, shadow],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: accent.withAlpha(77)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        leading: Container(
  width: 55,  // Маленькая резиновая иконка
  height: 55,
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(10),
    color: gold.withOpacity(0.1),
  ),
  child: item.imagePath != null 
    ? ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.file(
          File(item.imagePath!), 
          fit: BoxFit.cover, // Тоже резиновая посадка внутри квадрата
        ),
      )
    : Icon(Icons.restaurant, color: gold, size: 20),
),
        title: Text(
          item.name.toUpperCase(),
          style: const TextStyle(color: cream, fontWeight: FontWeight.w900, fontSize: 14, letterSpacing: 0.5),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min, // Добавили, чтобы колонка не росла лишнего
          children: [
            Text(item.desc, style: TextStyle(color: cream.withAlpha(150), fontSize: 11)),
            const SizedBox(height: 10),
            _buildMacroLine("P/F/C/S:", [item.proteins, item.fats, item.carbs, item.sugar], accColor: cream),
            _buildMicroSection(item, cream),
          ],
        ),
        // --- ОБНОВЛЕННЫЙ ТРЕЙЛИНГ С ПРОВЕРКОЙ ---
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Калории (твои резиновые)
            Text('${item.calories}\nkcal', 
              textAlign: TextAlign.center,
              style: const TextStyle(color: cream, fontWeight: FontWeight.bold, fontSize: 10)),
            
            const SizedBox(width: 4), // Небольшой отступ

            IconButton(
              icon: Icon(Icons.add_circle_outline, color: gold, size: 28),
              onPressed: () {
                // ПРОВЕРКА: Если мы зашли просто посмотреть (из Архива или при создании в Сканере)
                if (widget.mealName == 'ARCHIVE' || widget.mealName == 'BIO-SCAN') {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("To add to Diary, please start from Breakfast/Lunch"),
                      backgroundColor: Color(0xFF033E40), // Твой темный цвет
                      duration: Duration(seconds: 2),
                    ),
                  );
                } else {
                  // ПУТЬ ДЛЯ ЕДЫ: Если зашли из Блокнота (Lunch, Dinner и т.д.)
                  _showWeightDialog(item); 
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMicroSection(LibraryProduct item, Color accColor) {
    List<String> microInfos = [];
    // Добавляем только если значение реально есть
    if (item.potassium != "0" && item.potassium.isNotEmpty) microInfos.add("K:${item.potassium}");
    if (item.magnesium != "0" && item.magnesium.isNotEmpty) microInfos.add("Mg:${item.magnesium}");
    if (item.calcium != "0" && item.calcium.isNotEmpty) microInfos.add("Ca:${item.calcium}");
    if (item.zinc != "0" && item.zinc.isNotEmpty) microInfos.add("Zn:${item.zinc}");
    if (item.vitC != "0" && item.vitC.isNotEmpty) microInfos.add("VC:${item.vitC}");
    if (item.vitD != "0" && item.vitD.isNotEmpty) microInfos.add("VD:${item.vitD}");
    if (item.vitB12 != "0" && item.vitB12.isNotEmpty) microInfos.add("B12:${item.vitB12}");

    if (microInfos.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(color: accent.withAlpha(30), height: 10),
        Wrap(
          spacing: 6, // Расстояние между витаминками
          runSpacing: 2, // Расстояние между строчками, если не влезло
          children: microInfos.map((micro) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(20),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(micro, style: TextStyle(color: accColor, fontSize: 9, fontWeight: FontWeight.w500)),
          )).toList(),
        ),
      ],
    );
  }

  Widget _buildValueText(String value, Color accColor, String unit) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Text("$value$unit", style: TextStyle(color: accColor, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }

 Widget _buildMacroLine(String label, List<String> values, {required Color accColor}) {
    return Row(
      children: [
        Text(label, style: TextStyle(color: accColor.withAlpha(150), fontSize: 10, fontWeight: FontWeight.w600)),
        const SizedBox(width: 4),
        // Просто перебираем значения и добавляем "g" (граммы) к каждому
        ...values.map((val) => _buildValueText(val, accColor, "g")).toList(),
      ],
    );
  }
  void _showWeightDialog(LibraryProduct item) {
  final TextEditingController weightController = TextEditingController(text: '100');
  double unit = MediaQuery.of(context).size.width / 100;

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: const Color(0xFF05100A),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: gold, width: 1),
        borderRadius: BorderRadius.circular(15)
      ),
      title: Text(item.name.toUpperCase(), 
        style: TextStyle(color: gold, fontSize: unit * 4, fontWeight: FontWeight.bold)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Enter weight in grams:', style: TextStyle(color: Colors.white70, fontSize: unit * 3)),
          TextField(
            controller: weightController,
            keyboardType: TextInputType.number,
            autofocus: true,
            style: TextStyle(color: gold, fontWeight: FontWeight.bold, fontSize: unit * 5),
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: gold.withOpacity(0.5))),
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: gold)),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context), 
          child: const Text('CANCEL', style: TextStyle(color: Colors.white54))
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: gold),
          onPressed: () {
            double weight = double.tryParse(weightController.text) ?? 100;
            double ratio = weight / 100;
            final metrics = Provider.of<MetricsProvider>(context, listen: false);

            // Пересчитываем всё на введенный вес
            double tKcal = (double.tryParse(item.calories) ?? 0) * ratio;
            double tP = (double.tryParse(item.proteins) ?? 0) * ratio;
            double tF = (double.tryParse(item.fats) ?? 0) * ratio;
            double tC = (double.tryParse(item.carbs) ?? 0) * ratio;

            metrics.addMealData(
              mealName: widget.mealName, 
              foodName: item.name,
              kcal: tKcal, p: tP, f: tF, c: tC,
              imagePath: item.imagePath, 
            );

            // ГЛАВНЫЙ ТРЮК: Трижды выходим назад
  Navigator.pop(context); // 1. Закрыли диалог с весом
  Navigator.pop(context); // 2. Закрыли Библиотеку
  
  // Если мы зашли из меню "8 кнопок", нам нужно закрыть и его:
  if (Navigator.canPop(context)) {
    Navigator.pop(context); // 3. Закрыли категории
  }

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text("${item.name} added!"), backgroundColor: gold),
  );
},
          child: const Text('ADD', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        ),
      ],
    ),
  );
}
}