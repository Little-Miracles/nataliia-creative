import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// Убедись, что путь к exercise.dart верный. Если будет ругаться — проверь папку.
import 'package:smart_body_life/screens/workout_data_models.dart'; 
import 'package:smart_body_life/providers/active_session_provider.dart';
import '../providers/workout_provider.dart';

class EquipmentSelectionScreen extends StatefulWidget {
  const EquipmentSelectionScreen({super.key});

  @override
  State<EquipmentSelectionScreen> createState() => _EquipmentSelectionScreenState();
}

class _EquipmentSelectionScreenState extends State<EquipmentSelectionScreen> {
  final List<String> allEquipment = [
    'Dumbbells',
    'Barbell',
    'Resistance Band',
    'Kettlebell',
    'Bench',
    'Treadmill',
    'Pull-up Bar',
    'No Equipment'
  ];

  List<String> tempSelected = [];

  @override
  void initState() {
    super.initState();
    tempSelected = List.from(context.read<WorkoutProvider>().selectedEquipment);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF05100A),
      appBar: AppBar(
        title: const Text('Select Equipment', style: TextStyle(color: Color(0xFFFFAB00))),
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: allEquipment.length,
              itemBuilder: (context, index) {
                final item = allEquipment[index];
                final isSelected = tempSelected.contains(item);

                return CheckboxListTile(
                  title: Text(item, style: const TextStyle(color: Colors.white)),
                  value: isSelected,
                  activeColor: const Color(0xFFFFAB00),
                  checkColor: Colors.black,
                  onChanged: (bool? value) {
                    if (value == true) {
                      // ТВОЯ ТАБЛИЧКА-ДИАЛОГ
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          backgroundColor: const Color(0xFF1A1A1A),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: const BorderSide(color: Color(0xFFFFAB00), width: 0.5),
                          ),
                          title: const Text("ADD TO SESSION?", 
                            style: TextStyle(color: Color(0xFFFFAB00), fontSize: 16, fontWeight: FontWeight.bold)),
                          content: Text("Add $item to your notebook?", 
                            style: const TextStyle(color: Colors.white70)),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context), 
                              child: const Text("CANCEL", style: TextStyle(color: Colors.white24))
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFFAB00)),
                              onPressed: () {
  setState(() {
    tempSelected.add(item);
  });
  
  final exerciseObj = Exercise(
    id: item, 
    title: item, 
    image: '', 
    machineCode: '', 
    targetMuscles: 'Custom', 
    category: 'Custom',
    kcal: '0', 
    sets: 0, 
    reps: '0', 
    isCompleted: false, 
    elapsedSeconds: 0, 
    restTime: '0s'
  );
  
  final activeSession = context.read<ActiveSessionProvider>();
  
  // 1. Добавляем упражнение
  activeSession.addToRunningWorkout(exerciseObj);
  
  // 2. ЗАСТАВЛЯЕМ ПЕРЕПРЫГНУТЬ НА ВКЛАДКУ BUILD
  activeSession.jumpToBuild(); 
  
  // 3. Обновляем данные
  activeSession.refresh();

  Navigator.pop(context); // Закрыть диалог
  Navigator.pop(context); // Вернуться из этого экрана
},
                              child: const Text("ADD", 
                                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      );
                    } else {
                      setState(() {
                        tempSelected.remove(item);
                      });
                    }
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFAB00),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              onPressed: () {
  final activeSession = context.read<ActiveSessionProvider>();

  for (String item in tempSelected) {
    final exerciseObj = Exercise(
      id: item, title: item, image: '', machineCode: '', targetMuscles: 'Custom', category: 'Custom',
      kcal: '0', sets: 0, reps: '0', isCompleted: false, elapsedSeconds: 0, restTime: '0s'
    );
    activeSession.addToRunningWorkout(exerciseObj);
  }

  // Переключаем на Блокнот и обновляем
  activeSession.jumpToBuild();
  activeSession.refresh();

  Navigator.pop(context);
},
              child: const Text('SAVE SELECTION', 
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
            ),
          ),
        ],
      ),
    );
  }
}