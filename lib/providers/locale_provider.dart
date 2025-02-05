import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider with ChangeNotifier {
  static const String _localeKey = 'locale';
  final SharedPreferences prefs;
  late Locale _locale;

  LocaleProvider(this.prefs) {
    _loadLocale();
  }

  Locale get locale => _locale;

  void _loadLocale() {
    final savedLocale = prefs.getString(_localeKey);
    _locale = savedLocale == 'en' ? const Locale('en') : const Locale('es');
    notifyListeners();
  }

  Future<void> setLocale(Locale locale) async {
    _locale = locale;
    await prefs.setString(_localeKey, locale.languageCode);
    notifyListeners();
  }

  Future<void> changeLanguage(String languageCode) async {
    await setLocale(Locale(languageCode));
  }
}
