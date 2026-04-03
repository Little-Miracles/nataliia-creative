import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_body_life/providers/metrics_provider.dart';
// Используем относительные пути, чтобы не путать систему
import '../screens/workout_data_models.dart'; 
import '../providers/active_session_provider.dart';
import '../screens/smart_weight_input.dart';

class NotebookWorkCard extends StatefulWidget {
  final Exercise exercise;
  const NotebookWorkCard({super.key, required this.exercise});

  @override
  State<NotebookWorkCard> createState() => _NotebookWorkCardState();
}

class _NotebookWorkCardState extends State<NotebookWorkCard> {
  DateTime? _startTime; // Засекаем время начала подхода
  bool isExpanded = false; 
  final TextEditingController _val1 = TextEditingController(); // Вес / Скорость
  final TextEditingController _val2 = TextEditingController(); // Повторы / Минуты
  final TextEditingController _rest = TextEditingController(); // Отдых

  @override
  void dispose() {
    _val1.dispose();
    _val2.dispose();
    _rest.dispose();
    super.dispose();
  }

double _calculateLiveKcal() {
  final String title = widget.exercise.title.toLowerCase();
  final String category = widget.exercise.category.toLowerCase();
  
  bool isCardio = category.contains("cardio") || category.contains("outdoor") ||
                  title.contains('run') || title.contains('walk') || 
                  title.contains('cycl') || title.contains('elliptical');

  double val1 = double.tryParse(_val1.text) ?? 0; // Вес или Скорость
  double val2 = double.tryParse(_val2.text) ?? 0; // Повторы или Минуты

  if (isCardio) {
    // Подтягиваем вес из MetricsProvider (через context)
    final metrics = Provider.of<MetricsProvider>(context, listen: false);
    double userWeight = metrics.currentWeight > 0 ? metrics.currentWeight : 70.0;

    double speed = val1;
    double minutes = val2;
    if (minutes > 0) {
      double met = (speed * 0.1) + 3.5;
      return (met * 3.5 * userWeight / 200) * minutes;
    }
    return 0;
  } else {
    // СИЛОВАЯ ФОРМУЛА
    return (val1 * val2 * 0.012) + 0.5;
  }
}

  @override
  Widget build(BuildContext context) {
    final session = context.watch<ActiveSessionProvider>();
    final String cat = widget.exercise.category.toLowerCase();

    return Container(
      margin: const EdgeInsets.only(bottom: 15, left: 15, right: 15),
decoration: BoxDecoration(
  color: const Color(0xFF111111),
  borderRadius: BorderRadius.circular(20),
  // ТОНКИЙ ЗОЛОТОЙ БОРДЕР (как у плюсика)
  border: Border.all(
    color: isExpanded 
        ? const Color(0xFFFFAB00).withOpacity(0.8) // Яркое золото при открытии
        : const Color(0xFFFFAB00).withOpacity(0.2), // Тонкое приглушенное золото в покое
    width: 0.8, // Делаем его очень тонким для изящности
  ),
  // Добавим легкое свечение, когда карточка открыта
  boxShadow: [
    if (isExpanded)
      BoxShadow(
        color: const Color(0xFFFFAB00).withOpacity(0.15),
        blurRadius: 15,
        spreadRadius: -2,
        offset: const Offset(0, 5),
      ),
    BoxShadow(
      color: Colors.black.withOpacity(0.5),
      blurRadius: 10,
      offset: const Offset(0, 4),
    ),
  ],
),
      child: Column(
        children: [
          ListTile(
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;
                if (isExpanded) {
                  _startTime = DateTime.now(); 
                }
              });
            }, // Скобка и запятая теперь на месте, ListTile видит свои параметры дальше
            leading: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.white, 
                borderRadius: BorderRadius.circular(10),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  widget.exercise.image ?? '',
                  width: 50, height: 50, fit: BoxFit.contain,
                ),
              ),
            ),
            title: Text(
              widget.exercise.title.toUpperCase(), 
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)
            ),
            subtitle: Text(
              widget.exercise.category.toUpperCase(),
              style: TextStyle(color: const Color(0xFFC5A059).withOpacity(0.6), fontSize: 10),
            ),
            // 4. БЛОК УПРАВЛЕНИЯ (КОРЗИНКА И БЛОКНОТИК)
            trailing: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 24),
                  onPressed: () {
                    // Удаление тренажера
                    session.addToRunningWorkout(widget.exercise);
                  },
                ),
                Icon(
                  Icons.edit_note, 
                  color: isExpanded ? const Color(0xFFFFAB00) : Colors.white24, 
                  size: 32,
                ),
              ],
            ),
          ), // ЗДЕСЬ МЫ ЗАКРЫЛИ ListTile
          
          // РАЗВОРАЧИВАЮЩАЯСЯ ПАНЕЛЬ УПРАВЛЕНИЯ
          // Внутри Column, где находится разворачивающаяся панель
if (isExpanded) 
  Padding(
    padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
    child: Column(
      children: [
        const Divider(color: Colors.white10, height: 20),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Ввод данных
            Expanded(child: _buildSmartInputRow(cat, context)),
            
           // УМНЫЙ ТАЙМЕР: Появляется только если есть данные
            AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: (_val1.text.isNotEmpty || _val2.text.isNotEmpty) ? 1.0 : 0.0,
              // МЫ ДОБАВИЛИ COLUMN, ЧТОБЫ ПОСТАВИТЬ ТЕКСТ НАД КНОПКОЙ
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // --- ВОТ ОНИ — ЖИВЫЕ КАЛОРИИ ПРЯМО НА ЭКРАНЕ ---
                  Text(
                    "${_calculateLiveKcal().toStringAsFixed(1)} kcal",
                    style: const TextStyle(
                      color: Color(0xFFFFAB00), // Твое золото
                      fontSize: 10, 
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  const SizedBox(height: 4), // Небольшой отступ до кнопки
                  
                  GestureDetector(
                    // ВЕРНИ ЭТОТ КУСОК (убери C=)
onTap: () {
                      if (_val1.text.isNotEmpty || _val2.text.isNotEmpty) {
                        final workDuration = DateTime.now().difference(_startTime ?? DateTime.now());
                        
                        // Сначала считаем калории, которые пользователь видит на карточке
                        double finalKcal = _calculateLiveKcal();

                        session.saveSetToNotebook(
                          widget.exercise.title, 
                          double.tryParse(_val1.text) ?? 0, 
                          int.tryParse(_val2.text) ?? 0, 
                          Duration(seconds: int.tryParse(_rest.text) ?? 0),
                          workDuration, 
                          finalKcal, // <-- ВОТ ОН, ТОТ САМЫЙ 6-й АРГУМЕНТ!
                        );
                        
                        _val1.clear(); 
                        _val2.clear(); 
                        _rest.clear();
                        setState(() => isExpanded = false);
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 5, left: 10),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFFFFAB00).withOpacity(0.5), width: 1),
                      ),
                      child: const Icon(Icons.timer_outlined, color: Color(0xFFFFAB00), size: 22),
                    ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
 Widget _buildSmartInputRow(String cat, BuildContext context) {
  final String category = cat.toLowerCase().trim();

  // В файле notebook_work_card.dart замени этот кусочек:

  // 1. Сначала проверяем КАРДИО
 if (category.contains("cardio") || category.contains("outdoor")) {
    return Row(
      children: [
        _miniInput("SPEED", _val1, hint: "km/h"), // Скорость с табло
        const SizedBox(width: 10),
        _miniInput("MINS", _val2, hint: "00"),    // ТОЛЬКО МИНУТЫ С ТАБЛО
        const SizedBox(width: 10),
        _miniInput("REST", _rest),
      ],
    );
  }

  // 2. Затем проверяем СИЛОВЫЕ (МАШИНЫ И ВЕСА)
  // SmartWeightInput сам решит: калькулятор для штанг или просто WEIGHT для машин
  else if (category.contains("machine") || category.contains("weight")) {
    return Row(
      children: [
        SmartWeightInput(exercise: widget.exercise, controller: _val1),
        const SizedBox(width: 10),
        _miniInput("REPS", _val2),
        const SizedBox(width: 10),
        _miniInput("REST", _rest),
      ],
    );
  } 

  // 3. Остальное (Йога/Плавание)
  else {
    return Row(
      children: [
        _miniInput("TIME", _val1, hint: "min"),
        const SizedBox(width: 10),
        _miniInput("INTENS", _val2, hint: "1-10"),
        const SizedBox(width: 10),
        _miniInput("REST", _rest),
      ],
    );
  }
}
  Widget _miniInput(String label, TextEditingController ctrl, {bool enabled = true, String? hint}) {
  return Expanded(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ЗОЛОТОЙ УЗКИЙ ЗАГОЛОВОК (как Session Data)
        Text(
          label,
          style: TextStyle(
            color: const Color(0xFFFFAB00).withOpacity(0.8), // Твое золото
            fontSize: 10,
            fontWeight: FontWeight.w300,
            letterSpacing: 1.5, // Раздвигаем буквы для "элитного" вида
            fontFamily: 'RobotoCondensed', // Если есть в проекте, или просто используй w300
          ),
        ),
        const SizedBox(height: 8), // Подняли заголовок повыше
        // IgnorePointer — секретный ингредиент. 
          // Если поле для калькулятора (enabled: false), оно пропускает клик сквозь себя.
        IgnorePointer(
          ignoring: !enabled, 
          child: TextField(
          controller: ctrl,
          readOnly: !enabled, 
          selectionControls: enabled ? null : EmptyTextSelectionControls(),
          enableInteractiveSelection: enabled,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          // СЕРЕБРЯНЫЕ ТОНКИЕ ЦИФРЫ
          style: const TextStyle(
            color: Color(0xFFC0C0C0), // Silver
            fontSize: 22, // Чуть крупнее, раз они тонкие
            fontWeight: FontWeight.w200, // Максимально тонкий шрифт
            letterSpacing: 1.2,
          ),
          decoration: InputDecoration(
            hintText: hint ?? "0",
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.05), fontSize: 18),
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(vertical: 5),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white10, width: 0.5),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFFFAB00), width: 1),
            ),
          ),
        ),
          )
      ],
    ),
  );
}
}