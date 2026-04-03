import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static late SharedPreferences _prefs;

  // Инициализация памяти (запускаем один раз при старте)
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Сохранение языка
  static Future<void> saveLanguage(String code) async {
    await _prefs.setString('user_lang', code);
  }

  // Загрузка языка (если ничего нет — вернет 'en')
  static String getLanguage() {
    return _prefs.getString('user_lang') ?? 'en';
  }

  // Сохранение прогресса (для будущих артефактов)
  static Future<void> saveProgress(String key, int value) async {
    await _prefs.setInt(key, value);
  }

  static int getProgress(String key) {
    return _prefs.getInt(key) ?? 0;
  }
  
  // СОХРАНЕНИЕ СПИСКА АРТЕФАКТОВ
  static Future<void> saveCustomArtifacts(List<Map<String, dynamic>> artifacts) async {
    String jsonString = jsonEncode(artifacts);
    await _prefs.setString('custom_artifacts', jsonString);
  }

  // ЗАГРУЗКА СПИСКА АРТЕФАКТОВ
  static List<Map<String, dynamic>> getCustomArtifacts() {
    String? jsonString = _prefs.getString('custom_artifacts');
    if (jsonString == null) return [];
    List<dynamic> decoded = jsonDecode(jsonString);
    return decoded.map((item) => Map<String, dynamic>.from(item)).toList();
  }
  // МЕТОД ДЛЯ УДАЛЕНИЯ АРТЕФАКТА
  static void deleteCustomArtifact(String machineCode) {
    // 1. Берем текущий список из памяти
    List<Map<String, dynamic>> currentList = getCustomArtifacts();
    
    // 2. Убираем из него тот, чей код совпадает с выбранным
    currentList.removeWhere((item) => item['machineCode'] == machineCode);
    
    // 3. Сохраняем обновленный (укороченный) список обратно в память
    saveCustomArtifacts(currentList);
  }
  // МЕТОД ДЛЯ ОБНОВЛЕНИЯ ТОЛЬКО КАРТИНКИ АРТЕФАКТА
  static void updateArtifactImage(String machineCode, String newPath) {
    // 1. Загружаем все артефакты
    List<Map<String, dynamic>> currentList = getCustomArtifacts();
    
    // 2. Находим нужный по коду и меняем путь к фото
    for (var item in currentList) {
      if (item['machineCode'] == machineCode) {
        item['customImage'] = newPath;
        break;
      }
    }
    
    // 3. Сохраняем обновленный список обратно в память
    saveCustomArtifacts(currentList);
  }
}