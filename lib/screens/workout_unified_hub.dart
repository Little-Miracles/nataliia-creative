import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';
import 'package:smart_body_life/providers/custom_workout_provider.dart';
import 'package:smart_body_life/widgets/workout_chart.dart'; 
import '../providers/active_session_provider.dart'; 
import '../providers/workout_library_provider.dart';
import 'workout_data_models.dart';
import 'workout_execution_screen.dart';

class WorkoutUnifiedHub extends StatefulWidget {
  final String templateId;
  const WorkoutUnifiedHub({super.key, required this.templateId});

  @override
  State<WorkoutUnifiedHub> createState() => _WorkoutUnifiedHubState();
}

class _WorkoutUnifiedHubState extends State<WorkoutUnifiedHub> {
  int _currentIndex = 1; 

 @override
  Widget build(BuildContext context) {
    final session = Provider.of<ActiveSessionProvider>(context);
    final library = Provider.of<WorkoutLibraryProvider>(context);
// Делаем архив: заменили этот кусок на тот что под ним
  // 1. Ищем и сохраняем результат в переменную 'found' (чтобы не было дубля имени)
    //final found = session.savedWorkouts.firstWhereOrNull(
      //(w) => w.id.toString().trim() == widget.templateId.toString().trim()
    //) ?? library.templates.firstWhereOrNull(
     // (w) => w.id.toString().trim() == widget.templateId.toString().trim()
    //);
/// Достаем наш новый провайдер-архив
    final customProvider = Provider.of<CustomWorkoutProvider>(context);

    // 1. Ищем тренировку (сначала в архиве, потом в библиотеках)
    final found = customProvider.myCustomList.firstWhereOrNull(
      (w) => w.id.toString().trim() == widget.templateId.toString().trim()
    ) ?? session.savedWorkouts.firstWhereOrNull(
      (w) => w.id.toString().trim() == widget.templateId.toString().trim()
    ) ?? library.templates.firstWhereOrNull(
      (w) => w.id.toString().trim() == widget.templateId.toString().trim()
    );
    // 2. А теперь даем «паспорт» этому найденному объекту
    // Теперь это единственная переменная 'workout' в этом блоке
    //делаем архив - убираем строчку ниже:
    //final SavedWorkout? workout = found as SavedWorkout?;

    //делаем архив: вставили этот кусок-ниже:
    // 2. Создаем ПЕРЕМЕННУЮ ОДИН РАЗ (теперь ошибки дублирования не будет)
    SavedWorkout? workout;
    
    if (found is WorkoutTemplate) {
      // Если нашли в нашем новом архиве
      workout = SavedWorkout(
        id: found.id,
        name: found.name,
        exercises: List<Exercise>.from(found.exercises),
        sessionResults: found.sessionResults ?? [],
      );
    } else {
      // Если нашли в старых библиотеках
      workout = found as SavedWorkout?;
    }

    // 3. Если не нашли — выводим текст, а не черный экран
    if (workout == null) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(backgroundColor: Colors.black, elevation: 0),
        body: Center(
          child: Text("NOT FOUND: ${widget.templateId}", 
            style: const TextStyle(color: Colors.white24))
        ),
      );
    }

    // 4. Теперь 'workout' официально признан тренировкой, и ошибки исчезнут
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFFFFAB00)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(workout.name.toUpperCase(), // Ошибка 'name' пропадет
            style: const TextStyle(
              color: Color(0xFFC0C0C0), 
              fontWeight: FontWeight.w300, 
              fontSize: 18, 
              letterSpacing: 2
            )),
      ),
      body: Column(
        children: [
          Expanded(child: _buildBodyContent(workout)),
          _buildActionButtons(context, workout),
          const SizedBox(height: 50),
        ],
      ),
    );
  }

  Widget _buildBodyContent(SavedWorkout workout) {
    if (_currentIndex == 0) return _buildHistoryView(workout);
    
    if (_currentIndex == 2) {
      final customProvider = Provider.of<CustomWorkoutProvider>(context, listen: false);
      final template = customProvider.myCustomList.firstWhereOrNull((t) => t.id == workout.id);
      
      // Достаем историю. Важно: берем полную строку лога!
      final List<String> historyStrings = template?.history.map((h) {
        // Если в логе несколько строк (лесенка), склеиваем их через перевод строки
        return h.log.join('\n');
      }).toList() ?? [];
      
      return WorkoutProgressChart(history: historyStrings);
    }
    
    return Column(children: [_buildInfoCard(workout)]);
  }

  // ИСТОРИЯ: Нумерованный список из sessionResults
 Widget _buildHistoryView(SavedWorkout workout) {
    final customProvider = Provider.of<CustomWorkoutProvider>(context, listen: false);
    final template = customProvider.myCustomList.firstWhereOrNull((t) => t.id == workout.id);
    final history = template?.history ?? [];

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("PAST SESSIONS", 
            style: TextStyle(color: Color(0xFFFFAB00), fontWeight: FontWeight.bold, letterSpacing: 1.5)),
          const SizedBox(height: 15),
          Expanded(
            child: history.isEmpty 
              ? const Center(child: Text("NO HISTORY YET", style: TextStyle(color: Colors.white10)))
              : ListView.builder(
                  itemCount: history.length,
                  itemBuilder: (context, index) {
                    final session = history[index];
                    if (session.log.isEmpty) return const SizedBox();

                    String dateStr = DateFormat('dd.MM.yyyy | HH:mm').format(session.date);
                    String rawData = session.log.last;

                    List<String> mainParts = rawData.split('|');
                    String exercisesPart = mainParts[0].trim();
                    String summaryPart = mainParts.length > 1 ? mainParts.sublist(1).join(' | ').trim() : "";

                    // Читаем и \n, и ;
                    List<String> exerciseList = exercisesPart.split(RegExp(r'[;\n]')).where((e) => e.trim().isNotEmpty).toList();

                    return Container(
                      margin: const EdgeInsets.only(bottom: 15),
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0A0A0A),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.white.withOpacity(0.05)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("SESSION #${history.length - index}", 
                                style: const TextStyle(color: Colors.white24, fontSize: 10, fontWeight: FontWeight.bold)),
                              Text(dateStr, style: const TextStyle(color: Color(0xFFFFAB00), fontSize: 10)),
                            ],
                          ),
                          const SizedBox(height: 15),
                          
                          ...exerciseList.where((e) => e.trim().isNotEmpty).map((exText) {
                            String cleanText = exText.trim();
                            
                            // Умная проверка кардио
                            bool isCardio = cleanText.startsWith('C=');
                            if (!isCardio) {
                               String low = cleanText.toLowerCase();
                               isCardio = low.contains('run') || low.contains('walk') || low.contains('row') || 
                                          low.contains('stair') || low.contains('step') || low.contains('cardio');
                            }
                            if (cleanText.startsWith('C=')) cleanText = cleanText.substring(2);

                            List<String> parts = cleanText.split('=');
                            if (parts.length < 2) return const SizedBox();

                            String name = parts[0].trim();
                            // РАЗБИВАЕМ ЛЕСЕНКУ ПО @
                            List<String> sets = parts[1].split('@');
                            String kcal = parts.length > 2 ? parts[2] : "0.0";

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(name.toUpperCase(), 
                                    style: TextStyle(
                                      color: isCardio ? Colors.greenAccent : const Color(0xFFFFAB00), 
                                      fontWeight: FontWeight.bold, 
                                      fontSize: 12
                                    )),
                                  const SizedBox(height: 5),
                                  ...sets.map((s) => Text(s, style: const TextStyle(color: Colors.white70, fontSize: 11, fontFamily: 'monospace'))),
                                  Text("🔥 $kcal kcal", style: const TextStyle(color: Colors.white24, fontSize: 9)),
                                ],
                              ),
                            );
                          }),

                          if (summaryPart.isNotEmpty) ...[
                            const Divider(color: Colors.white10, height: 20),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(summaryPart, style: const TextStyle(color: Colors.white24, fontSize: 10)),
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(SavedWorkout workout) {
    // Считаем количество выполненных сессий
    final int sessionCount = workout.sessionResults.length;

    return Container(
      margin: const EdgeInsets.all(25),
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF0A0A0A),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFFAB00).withOpacity(0.15)),
      ),
      child: Column(
        children: [
          const Text("ROUTINE OVERVIEW", style: TextStyle(color: Colors.white24, fontSize: 10, letterSpacing: 2)),
          const SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Показываем количество тренажеров
              Text("⚙️ GEAR: ${workout.exercises.length}", 
                  style: const TextStyle(color: Color(0xFFFFAB00), fontSize: 13, fontWeight: FontWeight.w400)),
              const SizedBox(width: 25),
              // Теперь статус показывает реальный прогресс!
              Text("🏆 DONE: $sessionCount", 
                  style: const TextStyle(color: Color(0xFFFFAB00), fontSize: 13, fontWeight: FontWeight.w400)),
            ],
          ),
        ],
      ),
    );
  }

// --- ДО МОМЕНТА ИЗМЕНЕНИЯ (в самом конце файла WorkoutUnifiedHub) ---
Widget _buildActionButtons(BuildContext context, SavedWorkout workout) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _hubButton(icon: Icons.history, label: "HISTORY", isActive: _currentIndex == 0, onTap: () => setState(() => _currentIndex = 0)),
        
        _hubButton(
          icon: Icons.info_outline, 
          label: "DETAILS", 
          isActive: _currentIndex == 1,
          onTap: () => setState(() => _currentIndex = 1),
        ),

        // --- ВОТ ЭТО МЫ МЕНЯЕМ/ДОБАВЛЯЕМ (Кнопка START) ---
        _hubButton(
          icon: Icons.play_arrow,
          label: "START", 
          isActive: false, 
          onTap: () {
            final session = Provider.of<ActiveSessionProvider>(context, listen: false);
            session.startWorkoutFromTemplate(workout.name, workout.exercises);
            Navigator.push(context, MaterialPageRoute(builder: (context) => WorkoutExecutionScreen(workout: workout)));
          },
        ),
      ],
    );
  }

  Widget _hubButton({required IconData icon, required String label, required bool isActive, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 75, height: 75,
            decoration: BoxDecoration(
              color: isActive ? const Color(0xFFFFAB00) : Colors.black, 
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFFFAB00), width: 1.5),
            ),
            child: Icon(icon, color: isActive ? Colors.black : const Color(0xFFFFAB00), size: 35),
          ),
          const SizedBox(height: 10),
          Text(label, style: TextStyle(color: isActive ? Colors.white : Colors.white38, fontSize: 10, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}