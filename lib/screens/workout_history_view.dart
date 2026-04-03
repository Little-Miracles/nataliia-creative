import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; 
import 'workout_data_models.dart';

class WorkoutHistoryView extends StatelessWidget {
  final WorkoutTemplate workout;

  const WorkoutHistoryView({super.key, required this.workout});

  @override
  Widget build(BuildContext context) {
    final sortedHistory = workout.history.reversed.toList();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFFFFAB00)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("HISTORY: ${workout.name}", 
          style: const TextStyle(color: Color(0xFFFFAB00), fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 1)),
      ),
      body: sortedHistory.isEmpty 
        ? _buildEmptyState() 
        : ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: sortedHistory.length,
            itemBuilder: (context, index) {
              final session = sortedHistory[index];
              return _buildHistoryCard(session);
            },
          ),
    );
  }

Widget _buildHistoryCard(WorkoutSession session) {
    if (session.log.isEmpty) return const SizedBox();
    
    String rawData = session.log.last;
    
    List<String> mainParts = rawData.split('|');
    String exercisesPart = mainParts[0].trim();
    String summaryPart = mainParts.length > 1 ? mainParts.sublist(1).join(' | ').trim() : "";
    
    // Разбиваем на строки
    List<String> exerciseList = exercisesPart.split(RegExp(r'[;\n]')).where((e) => e.trim().isNotEmpty).toList();

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF111111),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DateFormat('dd MMMM yyyy | HH:mm').format(session.date).toUpperCase(),
                style: const TextStyle(color: Colors.white38, fontSize: 10),
              ),
              // --- ВОТ ОН: ГЛАВНЫЙ АКЦЕНТ НА НОМЕР СЕССИИ ---
              if (exercisesPart.contains("SESSION #"))
                Text(
                  exercisesPart.split('\n').firstWhere((s) => s.contains("SESSION #"), orElse: () => ""),
                  style: const TextStyle(color: Color(0xFFFFAB00), fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1),
                ),
            ],
          ),
          const SizedBox(height: 15),
          
          ...exerciseList.map((exText) {
            String cleanText = exText.trim();
            if (cleanText.isEmpty || cleanText.contains("SESSION #")) return const SizedBox(); // Пропускаем заголовок здесь, т.к. вывели его выше

            bool isCardio = cleanText.startsWith('C=');
            
            // Умная проверка названия (твоя логика)
            if (!isCardio) {
              String lowerText = cleanText.toLowerCase();
              isCardio = lowerText.contains('run') || lowerText.contains('walk') || 
                         lowerText.contains('row') || lowerText.contains('stair') || 
                         lowerText.contains('cycl') || lowerText.contains('elliptical');
            }

            if (cleanText.startsWith('C=')) {
              cleanText = cleanText.substring(2);
            }

            List<String> parts = cleanText.split('=');

            if (parts.length >= 2) {
              return _buildExerciseRow(
                name: parts[0].trim(),
                weight: parts[1].trim(),
                reps: parts.length > 2 ? parts[2].trim() : "",
                kcal: parts.length > 3 ? parts[3].trim() : "0.0",
                isCardio: isCardio,
              );
            }
            return const SizedBox();
          }),

          if (summaryPart.isNotEmpty) ...[
            const Divider(color: Colors.white10, height: 20),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                summaryPart, 
                style: const TextStyle(color: Colors.white24, fontSize: 11, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ],
      ),
    );
  }
 // --- ОБНОВЛЕННЫЙ ПОМОЩНИК (для лесенки подходов) ---
  Widget _buildExerciseRow({
    required String name, 
    required String weight, // Теперь тут вся строка с подходами через @
    required String reps,   // В этой версии reps нам не нужен, всё в weight
    required String kcal,
    bool isCardio = false,
  }) {
    // Разбиваем строку с подходами обратно в список
    List<String> allSets = weight.split('@');

    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name.toUpperCase(), 
               style: TextStyle(
                 color: isCardio ? Colors.greenAccent : const Color(0xFFFFAB00), 
                 fontWeight: FontWeight.bold, 
                 fontSize: 14
               )),
          const SizedBox(height: 8),
          
          // Рисуем каждый подход с новой строки
          ...allSets.map((setText) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              setText,
              style: const TextStyle(color: Colors.white70, fontSize: 12, fontFamily: 'monospace'),
            ),
          )),
          
          //const SizedBox(height: 4),
          //Text("🔥 TOTAL: $kcal kcal", style: const TextStyle(color: Colors.white38, fontSize: 11)),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Text("NO SESSIONS YET\nGO SMASH YOUR GOALS!", 
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white10, fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }
}