import 'package:flutter/material.dart';
import 'dart:math';
import 'package:provider/provider.dart';
import 'package:smart_body_life/providers/metrics_provider.dart';

class CalcData {
  final String idealWeight, water, protein, dailyCalories;
  final String bfNavy, bfCategoryNavy, bfBmi, bfCategoryBmi, currentWeight; 
  final String dailyFats, dailyCarbs; 
  final String neck;
  final String waist;
  final String hips;

  CalcData({
    required this.idealWeight, required this.water, required this.protein,
    required this.dailyCalories, required this.bfNavy, required this.bfCategoryNavy,
    required this.bfBmi, required this.bfCategoryBmi, required this.currentWeight,
    required this.dailyFats, required this.dailyCarbs,
    required this.neck, required this.waist, required this.hips,
  });
}

class CalcScreen extends StatefulWidget {
  const CalcScreen({super.key});
  @override
  State<CalcScreen> createState() => _CalcScreenState();
}

class _CalcScreenState extends State<CalcScreen> {
  static const Color gemEmerald = Color(0xFF004D33);
  static const Color gemSapphire = Color(0xFF082567);
  static const Color gemGold = Color(0xFFD4AF37);
  static const Color gemEmeraldLight = Color(0xFF10B981);

  final TextEditingController _ageController = TextEditingController(text: '61');
  final TextEditingController _heightController = TextEditingController(text: '158');
  final TextEditingController _weightController = TextEditingController(text: '75');
  final TextEditingController _waistController = TextEditingController(text: '92');
  final TextEditingController _neckController = TextEditingController(text: '40');
  final TextEditingController _hipsController = TextEditingController(text: '102'); 

  String _gender = 'female'; // Выбор пола
  String _goal = 'loss'; 
  String _errorMessage = '';
  CalcData? _calculatedData; 
  double _workoutsPerWeek = 1; 

  void _calculate() {
    setState(() { _errorMessage = ''; });
    double age = double.tryParse(_ageController.text) ?? 0;
    double height = double.tryParse(_heightController.text) ?? 0;
    double weight = double.tryParse(_weightController.text) ?? 0;
    double waist = double.tryParse(_waistController.text) ?? 0;
    double neck = double.tryParse(_neckController.text) ?? 0;
    double hips = double.tryParse(_hipsController.text) ?? 0;

    if (age < 1 || height < 50 || weight < 10) {
      setState(() { _errorMessage = 'Check input data'; }); return;
    }

    // РАСЧЕТ ИДЕАЛЬНОГО ВЕСА (Формула Лоренца)
    // $W_{ideal} = (H - 100) - \frac{H - 150}{K}$, где K=4 для мужчин, K=2 для женщин.
    double k = (_gender == 'male') ? 4 : 2;
    double idealW = (height - 100) - (height - 150) / k;

    // КАЛОРИИ (Mifflin-St Jeor)
    double bmr = (10 * weight) + (6.25 * height) - (5 * age) + (_gender == 'male' ? 5 : -161);
    double maintenance = bmr * ((_workoutsPerWeek < 1) ? 1.2 : (_workoutsPerWeek < 3) ? 1.375 : 1.55);

    double targetKcal = (_goal == 'loss') ? maintenance * 0.8 : (_goal == 'gain') ? maintenance * 1.15 : maintenance;
    double carbRatio = (_goal == 'loss') ? 0.40 : 0.50;

    // РАСЧЕТ ВОДЫ (33 мл на кг)
    double waterLiters = weight * 0.033;

    // МАКРОСЫ
    double pGrams = (age >= 60) ? (idealW * 1.2) : (weight * 1.5);
    double fGrams = (targetKcal * 0.25) / 9;
    double cGrams = (targetKcal * carbRatio) / 4;

    // BF (Navy)
    double bf;
    if (_gender == 'male') {
      bf = 495 / (1.0324 - 0.19077 * (log(waist - neck)/log(10)) + 0.15456 * (log(height)/log(10))) - 450;
    } else {
      bf = 495 / (1.29579 - 0.35004 * (log(waist + hips - neck)/log(10)) + 0.22100 * (log(height)/log(10))) - 450;
    }

    _calculatedData = CalcData(
      idealWeight: idealW.toStringAsFixed(1),
      water: waterLiters.toStringAsFixed(1),
      protein: pGrams.toStringAsFixed(0),
      dailyCalories: targetKcal.toStringAsFixed(0),
      currentWeight: weight.toStringAsFixed(1),
      bfNavy: bf.toStringAsFixed(1),
      bfCategoryNavy: '', bfBmi: '0', bfCategoryBmi: '',
      dailyFats: fGrams.toStringAsFixed(0),
      dailyCarbs: cGrams.toStringAsFixed(0),
      // Добавь эти три строки в самый конец списка:
      neck: neck.toStringAsFixed(1),
      waist: waist.toStringAsFixed(1),
      hips: hips.toStringAsFixed(1),
    );
    setState(() {});
  }

  void _apply() {
    if (_calculatedData != null) {
      context.read<MetricsProvider>().updateFromCalculator(_calculatedData!);
      Navigator.pop(context, _calculatedData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: const Text('SCIENTIFIC CALC', style: TextStyle(color: gemGold, fontSize: 16)), backgroundColor: Colors.transparent, centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(children: [
          // ВЫБОР ПОЛА
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            _genderBtn('FEMALE', _gender == 'female', () => setState(() => _gender = 'female')),
            const SizedBox(width: 20),
            _genderBtn('MALE', _gender == 'male', () => setState(() => _gender = 'male')),
          ]),
          const SizedBox(height: 25),
          // ВЫБОР ЦЕЛИ
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            _goalBtn('LOSS', _goal == 'loss', Colors.redAccent, () => setState(() => _goal = 'loss')),
            _goalBtn('MAINTAIN', _goal == 'maintain', gemEmeraldLight, () => setState(() => _goal = 'maintain')),
            _goalBtn('GAIN', _goal == 'gain', Colors.blueAccent, () => setState(() => _goal = 'gain')),
          ]),
          const SizedBox(height: 20),
          _inputRow('Age', _ageController, 'Height', _heightController),
          _inputRow('Weight', _weightController, 'Waist', _waistController),
          _inputRow('Neck', _neckController, 'Hips', _hipsController),
          const SizedBox(height: 15),
          _buildActivity(),
          const SizedBox(height: 25),
          _calcBtn(),
          if (_errorMessage.isNotEmpty) Padding(padding: const EdgeInsets.only(top: 15), child: Text(_errorMessage, style: const TextStyle(color: Colors.red, fontSize: 12))),
          if (_calculatedData != null) _buildResultsPanel(),
        ]),
      ),
    );
  }

  Widget _genderBtn(String t, bool a, VoidCallback o) {
    return GestureDetector(
      onTap: o,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
        decoration: BoxDecoration(color: a ? gemGold : gemSapphire.withAlpha(40), borderRadius: BorderRadius.circular(12), border: Border.all(color: a ? gemGold : Colors.white.withAlpha(20))),
        child: Text(t, style: TextStyle(color: a ? Colors.black : Colors.grey, fontWeight: FontWeight.bold, fontSize: 12)),
      ),
    );
  }

  Widget _goalBtn(String t, bool a, Color c, VoidCallback o) {
    return GestureDetector(onTap: o, child: Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), decoration: BoxDecoration(color: a ? c.withAlpha(40) : Colors.white.withAlpha(15), borderRadius: BorderRadius.circular(8), border: Border.all(color: a ? c : Colors.white.withAlpha(20))), child: Text(t, style: TextStyle(color: a ? c : Colors.grey, fontSize: 10, fontWeight: FontWeight.bold))));
  }

  Widget _inputRow(String l1, TextEditingController c1, String l2, TextEditingController c2) {
    return Padding(padding: const EdgeInsets.only(bottom: 10), child: Row(children: [Expanded(child: _field(l1, c1)), const SizedBox(width: 10), Expanded(child: _field(l2, c2))]));
  }

  Widget _field(String l, TextEditingController c) {
    return TextField(controller: c, keyboardType: TextInputType.number, style: const TextStyle(color: Colors.white, fontSize: 14), decoration: InputDecoration(labelText: l, labelStyle: const TextStyle(color: Colors.grey, fontSize: 11), filled: true, fillColor: gemSapphire.withAlpha(40), border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none)));
  }

  Widget _buildActivity() {
    return Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: gemEmerald.withAlpha(30), borderRadius: BorderRadius.circular(12)), child: Column(children: [Text('Workouts: ${_workoutsPerWeek.toInt()} per week', style: const TextStyle(color: Colors.grey, fontSize: 10)), Slider(value: _workoutsPerWeek, min: 0, max: 7, divisions: 7, activeColor: gemGold, inactiveColor: Colors.white.withAlpha(20), onChanged: (v) => setState(() => _workoutsPerWeek = v))]));
  }

  Widget _calcBtn() {
    return SizedBox(width: double.infinity, height: 50, child: ElevatedButton(onPressed: _calculate, style: ElevatedButton.styleFrom(backgroundColor: gemGold, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), child: const Text('CALCULATE', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))));
  }

  Widget _buildResultsPanel() {
    return Container(
      margin: const EdgeInsets.only(top: 15), padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: gemSapphire.withAlpha(50), borderRadius: BorderRadius.circular(15), border: Border.all(color: gemGold.withAlpha(40))),
      child: Column(children: [
        _resRow('IDEAL WEIGHT', '${_calculatedData!.idealWeight} kg', gemGold), // Важный элемент
        _resRow('DAILY WATER', '${_calculatedData!.water} L', Colors.blueAccent), // Важный элемент
        const Divider(color: Colors.white10),
        _resRow('TARGET CALORIES', '${_calculatedData!.dailyCalories} kcal', gemGold),
        _resRow('PROTEIN', '${_calculatedData!.protein} g', Colors.white),
        _resRow('CARBS (Target)', '${_calculatedData!.dailyCarbs} g', Colors.white),
        _resRow('FATS', '${_calculatedData!.dailyFats} g', Colors.white),
        _resRow('BODY FAT %', '${_calculatedData!.bfNavy}%', gemEmeraldLight),
        const SizedBox(height: 15),
        SizedBox(width: double.infinity, child: ElevatedButton(onPressed: _apply, style: ElevatedButton.styleFrom(backgroundColor: gemEmeraldLight), child: const Text('APPLY TO DASHBOARD', style: TextStyle(color: Colors.white)))),
      ]),
    );
  }

  Widget _resRow(String l, String v, Color c) {
    return Padding(padding: const EdgeInsets.symmetric(vertical: 4), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(l, style: const TextStyle(color: Colors.grey, fontSize: 10)), Text(v, style: TextStyle(color: c, fontWeight: FontWeight.bold, fontSize: 14))]));
  }
}