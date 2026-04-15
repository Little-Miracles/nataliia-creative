import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TranslationService {
  static Future<String> translateText(String text, String targetCode) async {
    final String cleanCode = targetCode.trim().toLowerCase();
    
    // 1. ОПРЕДЕЛЯЕМ ЯЗЫК (сохраняем твою логику)
    String lang;
    if (cleanCode == 'de' || cleanCode == 'german') {
      lang = 'de';
    } else if (cleanCode == 'fr' || cleanCode == 'french') {
      lang = 'fr';
    } else if (cleanCode == 'es' || cleanCode == 'spanish') {
      lang = 'es';
    } else {
      lang = 'uk'; // По умолчанию украинский
    }

    // 2. ПРОВЕРКА ЛИМИТА (3 раза в день)
    final prefs = await SharedPreferences.getInstance();
    final String today = DateTime.now().toString().substring(0, 10);
    int count = prefs.getInt('trans_count') ?? 0;
    String? lastDate = prefs.getString('trans_date');

    if (lastDate != today) {
      await prefs.setString('trans_date', today);
      await prefs.setInt('trans_count', 0);
      count = 0;
    }

    if (count >= 3) {
      // Сообщение на английском, как ты просила
      return "LIMIT 3/3 REACHED. TRY TOMORROW";
    }

    // 3. БЕСПЛАТНЫЙ ОБЛАЧНЫЙ ЗАПРОС
    final url = Uri.parse(
      "https://translate.googleapis.com/translate_a/single?client=gtx&sl=en&tl=$lang&dt=t&q=${Uri.encodeComponent(text)}"
    );

    try {
      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        await prefs.setInt('trans_count', count + 1);
        final data = jsonDecode(response.body);
        
        String result = data[0][0][0];

        // Твоя проверка на кириллицу (для испанского/немецкого/французского)
        if (lang != 'uk' && (result.contains('а') || result.contains('о'))) {
          return "SYNCHRONIZING ${cleanCode.toUpperCase()}... Tap again.";
        }

        return result;
      } else {
        return text; // Если ошибка связи — возвращаем английский оригинал
      }
    } catch (e) {
      return text; // Если нет интернета — возвращаем английский оригинал
    }
  }
}

// Утилитарные классы оставляем пустыми или удаляем, если они больше не вызываются в других местах
class OnDeviceTranslatorOptions {
  final String sourceLanguage;
  final String targetLanguage;
  OnDeviceTranslatorOptions({required this.sourceLanguage, required this.targetLanguage});
}