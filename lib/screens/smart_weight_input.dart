import 'package:flutter/material.dart';
import 'workout_data_models.dart'; // Подтягиваем модель Exercise
import 'barbell_calc_screen.dart';
import 'dumbbell_calc_screen.dart';

class SmartWeightInput extends StatelessWidget {
  final Exercise exercise;
  final TextEditingController controller;

  const SmartWeightInput({
    super.key,
    required this.exercise,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    // 1. ОПРЕДЕЛЯЕМ ТИП ТРЕНАЖЕРА
    final String title = exercise.title.toLowerCase();
    final bool isDumbbell = title.contains("db") || title.contains("dumbbell") || 
                            title.contains("kettlebell");
    final bool isBarbell = exercise.category.toLowerCase().contains("weight") && !isDumbbell;

    // 2. ЕСЛИ ЭТО СВОБОДНЫЙ ВЕС — РИСУЕМ КНОПКУ-ТРАНСФОРМЕР
    if (isDumbbell || isBarbell) {
      return Expanded(
        child: GestureDetector(
          onTap: () async {
            // Тот самый мостик: Кто спросил — тот и получил ответ
            final dynamic result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (c) => isDumbbell ? const DumbbellCalcScreen() : const BarbellCalcScreen(),
              ),
            );
            if (result != null) {
              controller.text = result.toString();
            }
          },
          behavior: HitTestBehavior.opaque,
          child: _buildCellFrame(
            // Если в названии есть KB или Kettlebell — пишем KETTLEBELL, иначе — DUMBBELLS
label: title.contains("kettlebell") ? "KETTLEBELL" : (isDumbbell ? "DUMBBELLS" : "BARBELL"),
            content: controller.text.isEmpty ? "TAP" : controller.text,
            isHint: controller.text.isEmpty,
          ),
        ),
      );
    }

    // 3. ДЛЯ ВСЕХ ОСТАЛЬНЫХ (МАШИНЫ) — РИСУЕМ ТВОЙ КЛАССИЧЕСКИЙ INPUT
    return Expanded(
      child: _buildStandardInput("WEIGHT", controller),
    );
  }

  // КРАСИВЫЙ КАРКАС ДЛЯ КНОПКИ (Трансформер)
  Widget _buildCellFrame({required String label, required String content, bool isHint = false}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyle(
            color: const Color(0xFFFFAB00).withOpacity(0.8),
            fontSize: 10,
            fontWeight: FontWeight.w300,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 5),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.white10, width: 0.5)),
          ),
          child: Text(
            content,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isHint ? const Color(0xFFFFAB00).withOpacity(0.4) : const Color(0xFFC0C0C0),
              fontSize: 22,
              fontWeight: FontWeight.w200,
              letterSpacing: 1.2,
            ),
          ),
        ),
      ],
    );
  }

  // СТАНДАРТНОЕ ПОЛЕ ВВОДА (Для машин)
  Widget _buildStandardInput(String label, TextEditingController ctrl) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyle(
            color: const Color(0xFFFFAB00).withOpacity(0.8),
            fontSize: 10,
            fontWeight: FontWeight.w300,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: ctrl,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          style: const TextStyle(color: Color(0xFFC0C0C0), fontSize: 22, fontWeight: FontWeight.w200),
          decoration: InputDecoration(
            hintText: "0",
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.05), fontSize: 18),
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(vertical: 5),
            enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white10, width: 0.5)),
            focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFFFFAB00), width: 1)),
          ),
        ),
      ],
    );
  }
}