import 'package:translator/translator.dart';

class TranslationService {
  // Singleton pattern to ensure a single instance and a single cache.
  static final TranslationService _instance = TranslationService._internal();
  factory TranslationService() {
    return _instance;
  }
  TranslationService._internal();

  final GoogleTranslator _translator = GoogleTranslator();
  final Map<String, String> _cache = {};

  Future<String> translate(String text, String toLanguageCode) async {
    final String cacheKey = '$toLanguageCode:$text';
    if (_cache.containsKey(cacheKey)) {
      return _cache[cacheKey]!;
    }

    try {
      final translation = await _translator.translate(text, to: toLanguageCode);
      final translatedText = translation.text;
      _cache[cacheKey] = translatedText;
      return translatedText;
    } catch (e) {
      print("Translation Error: $e");
      return text; // Return original text on error
    }
  }

  void clearCache() {
    _cache.clear();
    print("Translation cache cleared.");
  }
}
