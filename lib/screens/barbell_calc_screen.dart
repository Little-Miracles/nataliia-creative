import 'package:flutter/material.dart';

class BarbellCalcScreen extends StatefulWidget {
  const BarbellCalcScreen({super.key});

  @override
  State<BarbellCalcScreen> createState() => _BarbellCalcScreenState();
}

class _BarbellCalcScreenState extends State<BarbellCalcScreen> {
  final Color kAccentColor = const Color(0xFFFFAB00); // Оранжевый
  final Color kBlackMetallic = const Color(0xFF1A1A1A); // Вороново крыло

  double _barWeight = 20.0; // Вес грифа
  final Map<double, int> _platesOnSide = {}; // Кол-во блинов на ОДНОЙ стороне

  bool _includeCollars = false; // Состояние замков
  final double _collarWeight = 2.5; // Вес ОДНОГО замка

  // Список доступных блинов
  final List<double> _availablePlates = [25, 20, 15, 10, 5, 2.5, 1.25, 0.5];


  // Считаем общий вес: Гриф + (Блины на стороне * 2)
  double get _totalWeight {
    double platesWeight = 0;
    _platesOnSide.forEach((weight, count) {
      platesWeight += weight * count;
    });
    // Гриф + (блины * 2) + (замки * 2, если включены)
    double collarsTotal = _includeCollars ? (_collarWeight * 2) : 0.0;
    return _barWeight + (platesWeight * 2) + collarsTotal;
  }

  void _addPlate(double weight) {
    setState(() {
      _platesOnSide[weight] = (_platesOnSide[weight] ?? 0) + 1;
    });
  }

  void _removePlate(double weight) {
    if ((_platesOnSide[weight] ?? 0) > 0) {
      setState(() {
        _platesOnSide[weight] = _platesOnSide[weight]! - 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("BARBELL CONSTRUCTOR", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.black,
        foregroundColor: kAccentColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => setState(() => _platesOnSide.clear()),
          )
        ],
      ),
      body: Column(
        children: [
          // ВЕРХНЯЯ ПАНЕЛЬ: ТАБЛО С ОБЩИМ ВЕСОМ
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 30),
            color: kBlackMetallic,
            child: Column(
              children: [
                const Text("TOTAL WEIGHT", style: TextStyle(color: Colors.grey, fontSize: 12, letterSpacing: 2)),
                const SizedBox(height: 10),
                Text(
                  "${_totalWeight.toStringAsFixed(1)} kg",
                  style: TextStyle(color: kAccentColor, fontSize: 48, fontWeight: FontWeight.w900),
                ),
                Text("Bar ($_barWeight) + Plates (${(_totalWeight - _barWeight).toStringAsFixed(1)})", 
                  style: const TextStyle(color: Colors.white24, fontSize: 12)),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. ВЫБОР ГРИФА
                  const Text("1. BAR WEIGHT", style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [20.0, 15.0, 10.0, 8.0].map((w) => _buildBarButton(w)).toList(),
                  ),

                  const SizedBox(height: 30),

                  // 2. СПИСОК БЛИНОВ
                  const Text("2. ADD PLATES (Per Side)", style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 15),
                  
                  // Сетка или список блинов
                  ..._availablePlates.map((weight) => _buildPlateControl(weight)),
                  // 3. ЗАМКИ (COLLARS)
const Text("3. ADD COLLARS (Locks)", style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
const SizedBox(height: 15),
GestureDetector(
  onTap: () => setState(() => _includeCollars = !_includeCollars),
  child: Container(
    padding: const EdgeInsets.all(15),
    decoration: BoxDecoration(
      color: _includeCollars ? kAccentColor.withOpacity(0.2) : kBlackMetallic,
      borderRadius: BorderRadius.circular(15),
      border: Border.all(color: _includeCollars ? kAccentColor : Colors.white10),
    ),
    child: Row(
      children: [
        Icon(Icons.lock_outline, color: _includeCollars ? kAccentColor : Colors.white24),
        const SizedBox(width: 15),
        const Text("Olympic Collars (2.5kg x 2)", style: TextStyle(color: Colors.white)),
        const Spacer(),
        Switch(
  value: _includeCollars,
  activeTrackColor: kAccentColor.withOpacity(0.5), // Можно добавить это для красоты
  activeColor: kAccentColor, // Это заменяет цвет "пимпочки" по-новому
  onChanged: (val) => setState(() => _includeCollars = val),
),
      ],
    ),
  ),
),
const SizedBox(height: 30),

                  // Кнопка подтверждения результата (УСИЛЕННАЯ)
                  SizedBox(
                    width: double.infinity, // Растягиваем на всю ширину для удобства
                    height: 55,            // Делаем высокую "спортивную" кнопку
                    child: ElevatedButton(
                      onPressed: () {
                        // ГЛАВНОЕ: Возвращаем итоговый вес в предыдущее окно
                        Navigator.pop(context, _totalWeight); 
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kAccentColor, // Наш оранжевый
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15), // Скругление как у карточек
                        ),
                        elevation: 5,
                      ),
                      child: const Text(
                        "CONFIRM & USE WEIGHT", 
                        style: TextStyle(
                          color: Colors.black, 
                          fontWeight: FontWeight.w900, // Жирный шрифт
                          fontSize: 16,
                          letterSpacing: 1.1
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30), // Чтобы не прижималось к низу
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Кнопка выбора грифа
  Widget _buildBarButton(double weight) {
    bool isSelected = _barWeight == weight;
    return GestureDetector(
      onTap: () => setState(() => _barWeight = weight),
      child: Container(
        width: 75,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? kAccentColor : kBlackMetallic,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: isSelected ? kAccentColor : Colors.white10),
        ),
        child: Center(
          child: Text("${weight.toInt()}kg", 
            style: TextStyle(color: isSelected ? Colors.black : Colors.white, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  // Строка управления конкретным блином
  Widget _buildPlateControl(double weight) {
    int count = _platesOnSide[weight] ?? 0;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: kBlackMetallic,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          // Цветная метка блина
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: _getPlateColor(weight),
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: _getPlateColor(weight).withOpacity(0.3), blurRadius: 8)],
            ),
            child: Center(
              child: Text("${weight >= 1 ? weight.toInt() : weight}", 
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
            ),
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("$weight kg Plate", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              const Text("per each side", style: TextStyle(color: Colors.white24, fontSize: 10)),
            ],
          ),
          const Spacer(),
          // Кнопки управления количеством
          Row(
            children: [
              _buildRoundBtn(Icons.remove, () => _removePlate(weight), count > 0),
              SizedBox(
                width: 40,
                child: Center(
                  child: Text("$count", style: TextStyle(color: count > 0 ? kAccentColor : Colors.white24, fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
              _buildRoundBtn(Icons.add, () => _addPlate(weight), true),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildRoundBtn(IconData icon, VoidCallback onTap, bool active) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: active ? Colors.white10 : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: active ? Colors.white : Colors.white10, size: 20),
      ),
    );
  }

  Color _getPlateColor(double weight) {
    if (weight >= 25) return Colors.red[700]!;
    if (weight >= 20) return Colors.blue[700]!;
    if (weight >= 15) return Colors.yellow[700]!;
    if (weight >= 10) return Colors.green[700]!;
    return Colors.blueGrey[800]!;
  }
}
