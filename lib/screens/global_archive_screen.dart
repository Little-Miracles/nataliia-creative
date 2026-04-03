import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart'; // Добавь этот импорт для красивых названий месяцев
import 'package:smart_body_life/providers/custom_workout_provider.dart';
import 'package:smart_body_life/screens/workout_history_view.dart';

class GlobalArchiveScreen extends StatelessWidget {
  const GlobalArchiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final customProvider = context.watch<CustomWorkoutProvider>();
    final allWorkouts = customProvider.myCustomList;

    // 1. Собираем все тренировки, где есть история
    final archivedWorkouts = allWorkouts.where((w) => w.history.isNotEmpty).toList();

    // 2. Группируем данные: Год -> Месяц -> Список тренировок
    Map<int, Map<int, List<dynamic>>> groupedData = {};

    for (var workout in archivedWorkouts) {
      for (var session in workout.history) {
        int year = session.date.year;
        int month = session.date.month;

        groupedData.putIfAbsent(year, () => {});
        groupedData[year]!.putIfAbsent(month, () => []);
        
        // Чтобы не дублировать одну и ту же тренировку в месяце много раз
        if (!groupedData[year]![month]!.contains(workout)) {
          groupedData[year]![month]!.add(workout);
        }
      }
    }

    // Сортируем годы по убыванию (свежие сверху)
    var sortedYears = groupedData.keys.toList()..sort((a, b) => b.compareTo(a));

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFFFFAB00)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("GLOBAL HISTORY", 
          style: TextStyle(color: Color(0xFFFFAB00), fontSize: 16, letterSpacing: 2)),
      ),
      body: archivedWorkouts.isEmpty 
        ? _buildEmptyState() 
        : ListView(
            padding: const EdgeInsets.all(20),
            children: sortedYears.map((year) {
              return _buildYearFolder(context, year, groupedData[year]!);
            }).toList(),
          ),
    );
  }

  Widget _buildYearFolder(BuildContext context, int year, Map<int, List<dynamic>> monthsData) {
    // Сортируем месяцы по убыванию
    var sortedMonths = monthsData.keys.toList()..sort((a, b) => b.compareTo(a));

    return ExpansionTile(
      initiallyExpanded: true,
      iconColor: const Color(0xFFFFAB00),
      collapsedIconColor: Colors.white24,
      title: Text("$year", style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
      children: sortedMonths.map((month) {
        String monthName = DateFormat('MMMM').format(DateTime(year, month)).toUpperCase();
        return _buildMonthFolder(context, monthName, monthsData[month]!);
      }).toList(),
    );
  }

  Widget _buildMonthFolder(BuildContext context, String monthName, List<dynamic> workouts) {
    return Padding(
      padding: const EdgeInsets.only(left: 15),
      child: ExpansionTile(
        title: Text(monthName, style: const TextStyle(color: Color(0xFFFFAB00), fontSize: 18)),
        children: workouts.map((w) => ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          title: Text(w.name.toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 14)),
          subtitle: Text("Records: ${w.history.length}", style: const TextStyle(color: Colors.white24, fontSize: 10)),
          trailing: const Icon(Icons.chevron_right, color: Colors.white10),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) => WorkoutHistoryView(workout: w)
            ));
          },
        )).toList(),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Text("ARCHIVE IS EMPTY YET\nKEEP TRAINING TO FILL IT", 
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white10, fontSize: 10, letterSpacing: 2)),
    );
  }
}