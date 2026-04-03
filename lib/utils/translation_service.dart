import 'package:google_mlkit_translation/google_mlkit_translation.dart';

class TranslationService {
  static Future<String> translateText(String text, String targetCode) async {
    final String cleanCode = targetCode.trim().toLowerCase();
    
    TranslateLanguage targetLanguage;
    if (cleanCode == 'de' || cleanCode == 'german') {
      targetLanguage = TranslateLanguage.german;
    } else if (cleanCode == 'fr' || cleanCode == 'french') {
      targetLanguage = TranslateLanguage.french;
    } else if (cleanCode == 'es' || cleanCode == 'spanish') {
      targetLanguage = TranslateLanguage.spanish;
    } else {
      targetLanguage = TranslateLanguage.ukrainian;
    }

    final options = OnDeviceTranslatorOptions(
      sourceLanguage: TranslateLanguage.english,
      targetLanguage: targetLanguage,
    );

    final translator = OnDeviceTranslator(
      sourceLanguage: options.sourceLanguage, 
      targetLanguage: options.targetLanguage
    );

    try {
      // Пытаемся получить перевод
      final String result = await translator.translateText(text);
      
      // СРАЗУ ЗАКРЫВАЕМ, чтобы он не висел в памяти
      await translator.close(); 
      
      // Проверка на кириллицу в иностранном языке
      if (targetLanguage != TranslateLanguage.ukrainian && 
          (result.contains('а') || result.contains('о'))) {
        return "LOADING ${cleanCode.toUpperCase()}... Tap again.";
      }

      return result;
    } catch (e) {
      await translator.close();
      return "DOWNLOADING ${cleanCode.toUpperCase()}... Wait 30s.";
    }
  }
}

class OnDeviceTranslatorOptions {
  final TranslateLanguage sourceLanguage;
  final TranslateLanguage targetLanguage;

  OnDeviceTranslatorOptions({
    required this.sourceLanguage,
    required this.targetLanguage,
  });
}
class translateText {
  translateText(String s, String lang);
}
