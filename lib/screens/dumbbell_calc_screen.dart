import 'package:flutter/material.dart';


class DumbbellCalcScreen extends StatefulWidget {
  const DumbbellCalcScreen({super.key});

  @override
  State<DumbbellCalcScreen> createState() => _DumbbellCalcScreenState();
}

class _DumbbellCalcScreenState extends State<DumbbellCalcScreen> {
  final Color kAccentColor = const Color(0xFFFFAB00); // Наш оранжевый
  final Color kBlackMetallic = const Color(0xFF1A1A1A); // Вороново крыло

  double _currentWeight = 5.0; 
  int _quantity = 2; 
  final List<Map<String, dynamic>> _basket = [];

  @override
Widget build(BuildContext context) {
  // Ваш отличный расчет суммы
  double grandTotal = _basket.fold(0, (sum, item) => sum + (item['weight'] * item['qty']));

  return Scaffold(
    backgroundColor: Colors.black,
    appBar: AppBar(
      title: const Text("DUMBBELL CALCULATOR", style: TextStyle(fontWeight: FontWeight.bold)),
      backgroundColor: Colors.black,
      foregroundColor: kAccentColor,
    ),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // БЛОК 1: КАЛЬКУЛЯТОР (Ваши окошки)
          _buildCalculatorUnit(),
          
          const SizedBox(height: 30),

          // БЛОК 2: КОРЗИНКА И КНОПКА ПОДТВЕРЖДЕНИЯ
          if (_basket.isNotEmpty) ...[
            _buildBasketUnit(grandTotal), // Ваша "малина" (корзинка)
            
            const SizedBox(height: 30), // Отступ между корзинкой и кнопкой

            // ФИНАЛЬНАЯ КНОПКА ВЫХОДА С РЕЗУЛЬТАТОМ
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: kAccentColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                onPressed: () {
                  // Возвращаем итоговую сумму (grandTotal) назад в упражнение
                  Navigator.pop(context, grandTotal); 
                },
                child: const Text(
                  "CONFIRM & USE TOTAL", 
                  style: TextStyle(
                    color: Colors.black, 
                    fontWeight: FontWeight.w900, 
                    fontSize: 16
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ],
      ),
    ),
  );
}

  Widget _buildCalculatorUnit() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: kBlackMetallic,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: kAccentColor.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildCounter("WEIGHT (ea)", "$_currentWeight kg", 
                () => setState(() => _currentWeight += 0.5),
                () => setState(() { if (_currentWeight > 0.5) _currentWeight -= 0.5; })),
              
              const Text("X", style: TextStyle(color: Colors.white24, fontSize: 24, fontWeight: FontWeight.bold)),

              _buildCounter("QUANTITY", "$_quantity", 
                () => setState(() => _quantity++),
                () => setState(() { if (_quantity > 1) _quantity--; })),
            ],
          ),
          const SizedBox(height: 25),
          ElevatedButton(
            // Кнопка сработает только если выбран вес больше нуля
            onPressed: _currentWeight > 0 ? () {
              setState(() {
                _basket.add({'weight': _currentWeight, 'qty': _quantity});
                _currentWeight = 0.0;
                _quantity = 1;
              });
            } : null, 
            style: ElevatedButton.styleFrom(
              // Если вес 0 — кнопка станет тёмной и неактивной
              backgroundColor: _currentWeight > 0 ? kAccentColor : Colors.white10,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(
              "ADD TO SET", 
              style: TextStyle(
                color: _currentWeight > 0 ? Colors.black : Colors.white24, 
                fontWeight: FontWeight.bold
              )
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBasketUnit(double total) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("CURRENT SELECTION:", style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        ..._basket.map((item) => ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text("${item['qty']} x ${item['weight']} kg", style: const TextStyle(color: Colors.white)),
          trailing: IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
            onPressed: () => setState(() => _basket.remove(item)),
          ),
        )),
        const Divider(color: Colors.white10, height: 40),
        // Оборачиваем итог в золотистую рамку
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: kAccentColor.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: kAccentColor.withOpacity(0.2)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("GRAND TOTAL:", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              Text(
                "${total.toStringAsFixed(1)} kg", 
                style: TextStyle(color: kAccentColor, fontSize: 26, fontWeight: FontWeight.w900)
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCounter(String label, String value, VoidCallback onAdd, VoidCallback onRemove) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 10)),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(15)),
          child: Row(
            children: [
              IconButton(icon: const Icon(Icons.remove, color: Colors.white), onPressed: onRemove),
              Text(value, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              IconButton(icon: const Icon(Icons.add, color: Colors.white), onPressed: onAdd),
            ],
          ),
        ),
      ],
    );
  }
}