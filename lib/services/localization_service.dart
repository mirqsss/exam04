import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalizationService extends ChangeNotifier {
  static const String _localeKey = 'locale';
  final SharedPreferences _prefs;
  late Locale _currentLocale;

  LocalizationService(this._prefs) {
    _currentLocale = Locale(_prefs.getString(_localeKey) ?? 'ru');
  }

  Locale get currentLocale => _currentLocale;

  static const List<Locale> supportedLocales = [
    Locale('ru', ''), // Русский
    Locale('en', ''), // Английский
    Locale('kk', ''), // Казахский
  ];

  Future<void> setLocale(String languageCode) async {
    if (!supportedLocales.any((locale) => locale.languageCode == languageCode)) {
      return;
    }

    _currentLocale = Locale(languageCode);
    await _prefs.setString(_localeKey, languageCode);
    notifyListeners();
  }

  String getLanguageName(String languageCode) {
    switch (languageCode) {
      case 'ru':
        return 'Русский';
      case 'en':
        return 'English';
      case 'kk':
        return 'Қазақша';
      default:
        return 'Русский';
    }
  }
} 