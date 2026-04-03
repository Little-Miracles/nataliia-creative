import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../screens/workout_data_models.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('workouts.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 2, // <--- ПОМЕНЯЙ С 1 НА 2
      onCreate: _createDB,
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          // Если пользователь обновился, создаем новую таблицу
          await db.execute('''
            CREATE TABLE workout_history (
              id TEXT PRIMARY KEY,
              planId TEXT NOT NULL,
              date TEXT NOT NULL,
              log_json TEXT NOT NULL
            )
          ''');
        }
      },
    );
  }

  Future _createDB(Database db, int version) async {
    // Таблица планов
    await db.execute('''
      CREATE TABLE saved_workouts (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        exercises_json TEXT NOT NULL,
        results_json TEXT NOT NULL
      )
    ''');

    // ТАБЛИЦА ГЛОБАЛЬНОГО АРХИВА
    await db.execute('''
      CREATE TABLE workout_history (
        id TEXT PRIMARY KEY,
        planId TEXT NOT NULL,
        date TEXT NOT NULL,
        log_json TEXT NOT NULL
      )
    ''');
  }

  // СОХРАНЕНИЕ: Записываем тренировку в базу
  Future<void> saveWorkout(SavedWorkout workout) async {
    final db = await instance.database;

    // Превращаем сложные списки в простые строки JSON
    final String exercisesJson = jsonEncode(
      workout.exercises.map((e) => {
        'title': e.title,
        'category': e.category,
        'machineCode': e.machineCode,
        'targetMuscles': e.targetMuscles,
        'sets': e.sets,
        'reps': e.reps,
        'restTime': e.restTime,
      }).toList(),
    );

    final String resultsJson = jsonEncode(workout.sessionResults);

    await db.insert(
      'saved_workouts',
      {
        'id': workout.id,
        'name': workout.name,
        'exercises_json': exercisesJson,
        'results_json': resultsJson,
      },
      conflictAlgorithm: ConflictAlgorithm.replace, // Если ID совпадет, обновим данные
    );
  }

  // ЗАГРУЗКА: Достаем все тренировки из базы
  Future<List<SavedWorkout>> loadWorkouts() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query('saved_workouts');

    return List.generate(maps.length, (i) {
      // Превращаем JSON-строку обратно в список упражнений
      final List<dynamic> decodedExercises = jsonDecode(maps[i]['exercises_json']);
      final List<String> decodedResults = List<String>.from(jsonDecode(maps[i]['results_json']));

      return SavedWorkout(
        id: maps[i]['id'],
        name: maps[i]['name'],
        sessionResults: decodedResults,
        exercises: decodedExercises.map((e) => Exercise(
          title: e['title'],
          category: e['category'],
          machineCode: e['machineCode'],
          targetMuscles: e['targetMuscles'],
          sets: e['sets'],
          reps: e['reps'],
          restTime: e['restTime'],
        )).toList(),
      );
    });
  }
  // --- МЕТОДЫ ДЛЯ ГЛОБАЛЬНОГО АРХИВА ---

  // 1. Сохранение сессии в историю
  Future<void> addSessionToHistory(WorkoutSession session, String planId) async {
    final db = await instance.database;
    await db.insert('workout_history', {
      'id': session.id,
      'planId': planId,
      'date': session.date.toIso8601String(), // Дата в формате 2026-02-27...
      'log_json': jsonEncode(session.log),    // Список результатов ["20kg x 10", ...]
    });
  }

  // 2. Загрузка всей истории для конкретного графика
  Future<List<String>> getFullHistoryForPlan(String planId) async {
    final db = await instance.database;
    final result = await db.query(
      'workout_history',
      where: 'planId = ?',
      whereArgs: [planId],
      orderBy: 'date ASC',
    );

    List<String> fullHistory = [];
    for (var row in result) {
      // Исправляем прошлую ошибку с помощью 'as String'
      List<dynamic> logs = jsonDecode(row['log_json'] as String);
      fullHistory.addAll(logs.cast<String>());
    }

    // ВОТ ЭТА СТРОЧКА ДОЛЖНА БЫТЬ ТУТ:
    return fullHistory; 
  }
}