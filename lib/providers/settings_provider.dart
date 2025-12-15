import 'package:flutter/material.dart';
import '../services/translation_service.dart';

class SettingsProvider with ChangeNotifier {
  Locale _locale = const Locale('en');
  ThemeMode _themeMode = ThemeMode.light;
  double _fontScale = 1.0;

  Locale get locale => _locale;
  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  double get fontScale => _fontScale;

  void setLocale(Locale newLocale) {
    if (_locale != newLocale) {
      _locale = newLocale;
      TranslationService().clearCache();
      notifyListeners();
    }
  }

  void toggleTheme(bool isOn) {
    _themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  void setFontScale(double scale) {
    if (_fontScale != scale) {
      _fontScale = scale;
      notifyListeners();
    }
  }
}
