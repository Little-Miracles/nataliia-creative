import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:smart_body_life/screens/workout_data_models.dart';

class WorkoutLibraryProvider with ChangeNotifier {
  final List<WorkoutTemplate> _templates = [];
  
  List<WorkoutTemplate> get templates => _templates;
  List<WorkoutTemplate> get allTemplates => _templates;

  // Поиск для Хаба
  WorkoutTemplate? findTemplate(String idOrName) {
    return _templates.firstWhereOrNull(
      (t) => t.id.toString() == idOrName || t.name == idOrName
    );
  }

  // 1. СОЗДАЕМ ЛЕЙБЛ (Тренажеры)
  void createTemplateCustom(String id, String name, List<dynamic> exercises) {
    bool exists = _templates.any((t) => t.id.toString() == id.toString() || t.name == name);
    
    if (!exists) {
      final newTemplate = WorkoutTemplate(
        id: id.toString(),
        name: name,
        exercises: List<Exercise>.from(exercises), 
        history: [], 
      );
      _templates.add(newTemplate);
      notifyListeners();
    }
  }

  // 2. ЗАПИСЫВАЕМ ИСТОРИЮ (Кг/Калории)
  void addSessionToHistory(String templateId, String result) {
    int index = _templates.indexWhere((t) => t.id == templateId);
    
    if (index >= 0) {
      final sessionEntry = WorkoutSession(
        id: DateTime.now().toString(),
        date: DateTime.now(),
        log: [result], 
        exercises: List.from(_templates[index].exercises), // Те самые тренажеры
      );

      // Создаем копию истории и обновляем её
      List<WorkoutSession> updatedHistory = List.from(_templates[index].history);
      updatedHistory.add(sessionEntry);

      _templates[index] = WorkoutTemplate(
        id: _templates[index].id,
        name: _templates[index].name,
        exercises: _templates[index].exercises,
        history: updatedHistory,
      );
      
      notifyListeners();
    }
  }
}