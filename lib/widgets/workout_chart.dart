import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class WorkoutProgressChart extends StatefulWidget {
  final List<String> history;

  const WorkoutProgressChart({super.key, required this.history});

  @override
  State<WorkoutProgressChart> createState() => _WorkoutProgressChartState();
}

class _WorkoutProgressChartState extends State<WorkoutProgressChart> {
  int touchedSessionId = -1; // Теперь храним ID всей тренировки, а не одного столбика

  @override
  Widget build(BuildContext context) {
    if (widget.history.isEmpty) return const Center(child: Text("No history yet", style: TextStyle(color: Colors.white24)));

    List<Map<String, dynamic>> stream = [];
    
    // 1. ПАРСИНГ С ГРУППИРОВКОЙ ПО СЕССИЯМ
    for (int sIdx = 0; sIdx < widget.history.length; sIdx++) {
      String entry = widget.history[sIdx];
      try {
        String exercisesPart = entry.split('|')[0].trim();
        List<String> lines = exercisesPart.split('\n');
        for (var line in lines) {
          if (!line.contains('=')) continue;
          bool isCardioEntry = line.startsWith('C=');
          String cleanLine = isCardioEntry ? line.substring(2) : line;
          List<String> parts = cleanLine.split('=');
          if (parts.length < 2) continue;

          String setsData = parts[1].trim();
          List<String> individualSets = setsData.split('@');

          for (var setData in individualSets) {
            double wVal = 0;
            double kVal = 0;
            String repsLabel = "0";

            final valMatch = RegExp(r'(\d+\.?\d*)\s*(kg|km/h)').firstMatch(setData);
            if (valMatch != null) wVal = double.tryParse(valMatch.group(1)!) ?? 0.0;

            final kcalMatch = RegExp(r'(?:🔥|)\s*(\d+\.?\d*)\s*kcal').firstMatch(setData);
            if (kcalMatch != null) kVal = double.tryParse(kcalMatch.group(1)!) ?? 0.0;

            bool isActuallyCardio = setData.contains('km/h');
            if (isActuallyCardio) {
              final timeMatch = RegExp(r'\((\d{2}:\d{2})\)').firstMatch(setData);
              repsLabel = timeMatch != null ? timeMatch.group(1)! : "min";
            } else {
              final repsMatch = RegExp(r'x\s*(\d+)').firstMatch(setData);
              repsLabel = repsMatch != null ? repsMatch.group(1)! : "0";
            }

            stream.add({
              'weight': wVal,
              'kcal': kVal,
              'reps': repsLabel,
              'isCardio': isActuallyCardio,
              'sessionId': sIdx, // Привязываем упражнение к конкретной тренировке в истории
            });
          }
        }
      } catch (e) {
        debugPrint("Chart parse error: $e");
      }
    }

    // Ограничим отображение последними 15-20 записями, чтобы не было слишком мелко
    if (stream.length > 20) stream = stream.sublist(stream.length - 20);

    double maxVal = 50;
    for (var item in stream) {
      if (item['kcal'] > maxVal) maxVal = item['kcal'];
      if (item['weight'] > maxVal) maxVal = item['weight'];
    }
    double dynamicMaxY = (maxVal * 1.2).roundToDouble();

    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Text("WORKOUT ANALYTICS", style: TextStyle(color: Colors.white60, fontSize: 13, fontWeight: FontWeight.w600, letterSpacing: 0.5)),
        ),
        SizedBox(
          height: 380,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            reverse: true,
            child: Container(
              width: (stream.length * 70.0).clamp(MediaQuery.of(context).size.width, 5000.0),
              padding: const EdgeInsets.fromLTRB(10, 20, 20, 10),
              child: BarChart(
                BarChartData(
                  maxY: dynamicMaxY,
                  minY: 0,
                  alignment: BarChartAlignment.center,
                  groupsSpace: 40,
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchCallback: (FlTouchEvent event, barTouchResponse) {
                      setState(() {
                        if (!event.isInterestedForInteractions || barTouchResponse == null || barTouchResponse.spot == null) {
                          touchedSessionId = -1;
                          return;
                        }
                        int index = barTouchResponse.spot!.touchedBarGroupIndex;
                        touchedSessionId = stream[index]['sessionId']; // Выделяем всю сессию
                      });
                    },
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipColor: (_) => Colors.transparent,
                      tooltipMargin: 4,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        return BarTooltipItem(
                          rod.toY.toStringAsFixed(1),
                          TextStyle(color: rod.color?.withOpacity(1.0), fontWeight: FontWeight.bold, fontSize: 10),
                        );
                      },
                    ),
                  ),
                  gridData: FlGridData(show: true, drawVerticalLine: false, horizontalInterval: dynamicMaxY / 5),
                  borderData: FlBorderData(show: true, border: const Border(bottom: BorderSide(color: Colors.white24), left: BorderSide(color: Colors.white24))),
                  titlesData: FlTitlesData(
                    show: true,
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true, reservedSize: 42,
                        getTitlesWidget: (double v, TitleMeta meta) => Text(v.toInt().toString(), ...),
                      ),
                    ),
                    bottomTitles: AxisTitles(
  sideTitles: SideTitles(
    showTitles: true,
    reservedSize: 30,
    getTitlesWidget: (double v, TitleMeta meta) {
      int i = v.toInt();
      if (i >= 0 && i < stream.length) {
        final String label = stream[i]['reps'].toString();
        bool isCardio = stream[i]['isCardio'] == true;
        bool isFocused = touchedSessionId == -1 || touchedSessionId == stream[i]['sessionId'];
        double opacity = isFocused ? 1.0 : 0.2;

        return SideTitleWidget(
  meta: meta, // <--- ТЕПЕРЬ ОН ТРЕБУЕТ ВЕСЬ ОБЪЕКТ meta
  space: 4,
  child: Text(
    isCardio ? label : "x $label", 
    style: TextStyle(
      color: (isCardio ? Colors.greenAccent : const Color(0xFF2196F3)).withOpacity(opacity), 
      fontSize: 10, 
      fontWeight: FontWeight.bold,
    ),
  ),
);
      }
      return const SizedBox();
    },
  ),
),
                  ),
                  barGroups: List.generate(stream.length, (index) {
                    final item = stream[index];
                    // ГРУППОВОЙ ФОКУС: подсвечиваем, если ID сессии совпадает с нажатой
                    final bool isFocused = touchedSessionId == -1 || touchedSessionId == item['sessionId'];
                    final double opacity = isFocused ? 1.0 : 0.2;

                    return BarChartGroupData(
                      x: index,
                      showingTooltipIndicators: isFocused ? [0, 1] : [],
                      barRods: [
                        BarChartRodData(
                          toY: item['kcal'], color: const Color(0xFFFF8C00).withOpacity(opacity), width: 14, 
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                          rodStackItems: [
                            BarChartRodStackItem(item['kcal'] > 0.5 ? item['kcal'] - 0.5 : 0, item['kcal'], Colors.white.withOpacity(opacity)),
                          ],
                        ),
                        BarChartRodData(
                          toY: item['weight'].toDouble(), color: (item['isCardio'] ? Colors.greenAccent : const Color(0xFF2196F3)).withOpacity(opacity), width: 14, 
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                          rodStackItems: [
                            BarChartRodStackItem(item['weight'] > 0.5 ? item['weight'].toDouble() - 0.5 : 0, item['weight'].toDouble(), Colors.white.withOpacity(opacity)),
                          ],
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        _buildLegend(),
      ],
    );
  }

  Widget _buildLegend() => const Row(
    mainAxisAlignment: MainAxisAlignment.center, 
    children: [
      _Dot(Color(0xFFFF8C00)), Text(" ENERGY (kcal)  ", style: TextStyle(color: Colors.white38, fontSize: 9)),
      _Dot(Color(0xFF2196F3)), Text(" STRENGTH (kg)  ", style: TextStyle(color: Colors.white38, fontSize: 9)),
      _Dot(Colors.greenAccent), Text(" SPEED (km/h)", style: TextStyle(color: Colors.white38, fontSize: 9)),
    ]
  );
}

class _Dot extends StatelessWidget {
  final Color color;
  const _Dot(this.color);
  @override
  Widget build(BuildContext context) => Container(width: 6, height: 6, margin: const EdgeInsets.only(right: 4), decoration: BoxDecoration(color: color, shape: BoxShape.circle));
}
