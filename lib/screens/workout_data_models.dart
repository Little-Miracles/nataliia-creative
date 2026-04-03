// lib/screens/workout_data_models.dart
import 'package:smart_body_life/providers/active_session_provider.dart';

class Exercise {
  final String? id;
  String title;
  final String category; 
  String machineCode;
  final String targetMuscles;
  final String? kcal;
  int sets;
  final String reps;
  final String restTime;
  List<String>? alternativeIds;

  String? description;  
  String? setup;        
  String? instructions; 
  String? safety;       
  String? image;
  
  Map<String, String>? params;
  List<String>? multiImages; 
  Map<String, String>? optionInstructions;
  int selectedVariantIndex = -1; 

  double? actualWeight;
  int? actualReps;
  int? actualRestTime;
  bool isCompleted;
  int elapsedSeconds;

  Exercise({
    this.id,
    required this.title,
    required this.category, 
    required this.machineCode,
    required this.targetMuscles,
    this.kcal,
    required this.sets,
    required this.reps,
    required this.restTime,
    this.alternativeIds, 
    this.description,
    this.setup,
    this.instructions,
    this.safety,
    this.params,
    this.image,
    this.multiImages,
    this.optionInstructions,
    this.actualWeight,
    this.actualReps,
    this.actualRestTime,
    this.isCompleted = false,
    this.elapsedSeconds = 0,
  });
}

class WorkoutPlan {
  final String? id; 
  final String title;
  final String duration;
  final String frequency;
  final String level;
  final String description; 
  final List<Exercise> warmUp;
  final List<Exercise> mainWorkout;
  final List<Exercise> coolDown;

  WorkoutPlan({
    this.id, 
    required this.title,
    required this.duration,
    required this.frequency,
    required this.level,
    required this.description, 
    required this.warmUp,
    required this.mainWorkout,
    required this.coolDown,
  });

  String get planId => id ?? title;
  String get name => title;
  List<Exercise> get allExercises => [...warmUp, ...mainWorkout, ...coolDown];
}

class SavedWorkout {
  final String id;
  final String name;
  final List<Exercise> exercises;
  final List<String> sessionResults; 

  SavedWorkout({
    required this.id,
    required this.name,
    required this.exercises,
    this.sessionResults = const [], 
  });

  Map<String, List<ExerciseSet>> get sessionLog => {}; 
}

class WorkoutTemplate {
  final String id;
  String name;
  final List<dynamic> exercises; 
  List<WorkoutSession> history; 

  List<String>? sessionResults;

  WorkoutTemplate({
    required this.id,
    required this.name,
    required this.exercises,
    this.history = const [], 
    this.sessionResults,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'sessionResults': sessionResults,
    'history_logs': history.map((s) => s.log.isNotEmpty ? s.log.first : "").toList(),
  };

  factory WorkoutTemplate.fromJson(Map<String, dynamic> json) {
    final template = WorkoutTemplate(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      exercises: [], 
      history: [],   
    );

    template.sessionResults = json['sessionResults'] != null 
        ? List<String>.from(json['sessionResults']) 
        : [];

    if (json['history_logs'] != null) {
      List<String> logs = List<String>.from(json['history_logs']);
      template.history = logs.map((l) => WorkoutSession(
        id: DateTime.now().toString(),
        date: DateTime.now(),
        log: [l],
        exercises: [], // Оставляем для совместимости
      )).toList();
    }

    return template;
  }
}

class WorkoutSession {
  final String id;
  final DateTime date;
  List<String> log; 
  final List<dynamic> exercises; // Убираем вопрос, делаем обязательным

  WorkoutSession({
    required this.id,
    required this.date,
    required this.log,
    this.exercises = const [], // Если данных нет, пусть будет пустой список, а не ошибка
  });
}