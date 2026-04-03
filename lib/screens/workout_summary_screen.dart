import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_body_life/providers/active_session_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:smart_body_life/screens/workout_execution_screen.dart';

class WorkoutSummaryScreen extends StatelessWidget {
  final dynamic workout;

  const WorkoutSummaryScreen({super.key, required this.workout});

  @override
  Widget build(BuildContext context) {
    const Color goldColor = Color(0xFFFFAB00);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: goldColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          workout.name.toString().toUpperCase(),
          style: const TextStyle(color: goldColor, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        // ДОБАВИЛИ КНОПКУ ОБЩЕЙ АНАЛИТИКИ В APPBAR
        actions: [
          IconButton(
            icon: const Icon(Icons.analytics_outlined, color: goldColor),
            onPressed: () => _showAllExercisesAnalytics(context),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              itemCount: workout.exercises.length,
              itemBuilder: (context, index) {
                final ex = workout.exercises[index];
                return _buildExerciseCard(context, ex, goldColor); 
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: goldColor, width: 2), 
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                backgroundColor: Colors.transparent,
              ),
              onPressed: () {
  final session = context.read<ActiveSessionProvider>();
  session.startSession(workout);
  
  Navigator.push(
    context,
    MaterialPageRoute(
      // ВМЕСТО NotebookScreen ПИШЕМ WorkoutExecutionScreen
      builder: (context) => WorkoutExecutionScreen(workout: workout), 
    ),
  );
},
              child: const Text(
                "START WORKOUT",
                style: TextStyle(color: goldColor, fontWeight: FontWeight.bold, letterSpacing: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- МЕТОД ДЛЯ ОБЩЕЙ АНАЛИТИКИ ---
  void _showAllExercisesAnalytics(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF0A0A0A),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        height: MediaQuery.of(context).size.height * 0.8,
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text("FULL EVOLUTION", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: workout.exercises.length,
                itemBuilder: (context, index) {
                  final exName = workout.exercises[index].title.toString();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(exName.toUpperCase(), style: const TextStyle(color: Color(0xFFFFAB00), fontSize: 12)),
                      ),
                      SizedBox(height: 150, child: _buildSimpleChart(context, exName)),
                      const Divider(color: Colors.white10),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- ВСПОМОГАТЕЛЬНЫЙ МЕТОД ДЛЯ МАЛЕНЬКОГО ГРАФИКА ---
  Widget _buildSimpleChart(BuildContext context, String title) {
    // Тут упрощенная логика сбора данных для списка
    return const Center(child: Icon(Icons.show_chart, color: Colors.white24));
  }

  Widget _buildExerciseCard(BuildContext context, dynamic ex, Color gold) {
    final List<String> allLogs = List<String>.from(workout.sessionLog ?? []);
    final exerciseLogs = allLogs
        .where((log) => log.toLowerCase().contains(ex.title.toString().toLowerCase()))
        .toList();

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFF111111),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Text(ex.title.toString().toUpperCase(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: () => _showProgressChart(context, ex.title.toString()),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFFFAB00).withOpacity(0.5)),
                        ),
                        child: const Icon(Icons.insights, color: Color(0xFFFFAB00), size: 16),
                      ),
                    ),
                  ],
                ),
              ),
              if (ex.kcal != null)
                Text("${ex.kcal} KCAL", style: TextStyle(color: gold.withOpacity(0.7), fontSize: 10, fontWeight: FontWeight.w900)),
            ],
          ),
          const SizedBox(height: 12),
          if (exerciseLogs.isNotEmpty)
            ...exerciseLogs.map((log) {
              String cleanLog = log.contains(":") ? log.substring(log.lastIndexOf("SET")) : log;
              return Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle_outline, color: Colors.green, size: 12),
                    const SizedBox(width: 8),
                    Text(cleanLog, style: const TextStyle(color: Color(0xFFFFAB00), fontSize: 12, fontWeight: FontWeight.w300)),
                  ],
                ),
              );
            })
          else
            const Text("NO PREVIOUS RESULTS", style: TextStyle(color: Colors.white10, fontSize: 10)),
        ],
      ),
    );
  }

  void _showProgressChart(BuildContext context, String exerciseTitle) {
    final sessionProvider = context.read<ActiveSessionProvider>();
    List<FlSpot> spots = [];
    List<String> dates = [];
    final history = sessionProvider.savedWorkouts;
    
    int index = 0;
    for (var w in history) {
  // 1. Извлекаем все записи (строки) из Map, если они есть
  // Мы ищем по ключам (названиям упражнений)
  final exerciseLogs = w.sessionResults.where((result) => 
    result.toLowerCase().contains(exerciseTitle.toLowerCase())
  ).toList();

  if (exerciseLogs.isNotEmpty) {
    double maxWeight = 0;
    for (var log in exerciseLogs) {
      // Регулярное выражение остается прежним — оно ищет цифры перед "kg"
      final RegExp regExp = RegExp(r"(\d+\.?\d*)\s*kg");
      final match = regExp.firstMatch(log);
      if (match != null) {
        double weight = double.parse(match.group(1)!);
        if (weight > maxWeight) maxWeight = weight;
      }
    }
        if (maxWeight > 0) {
          spots.add(FlSpot(index.toDouble(), maxWeight));
          dates.add(w.name.contains('(') ? w.name.split('(').last.replaceAll(')', '') : "D${index+1}");
          index++;
        }
      }
    }

    if (spots.length < 2) {
      _showNoDataSnack(context);
      return;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0A0A0A),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(25),
        height: MediaQuery.of(context).size.height * 0.5,
        child: Column(
          children: [
            Text("EVOLUTION: $exerciseTitle", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            const SizedBox(height: 30),
            Expanded(
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 30)),
                    bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: (v, m) => Text(dates[v.toInt()%dates.length], style: const TextStyle(fontSize: 8, color: Colors.white24)))),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      color: const Color(0xFFFFAB00),
                      barWidth: 3,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showNoDataSnack(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Need at least 2 sessions")));
  }
}