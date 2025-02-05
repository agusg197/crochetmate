import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  static const String _themeKey = 'theme_mode';
  final SharedPreferences prefs;
  late ThemeMode _themeMode;

  ThemeProvider(this.prefs) {
    _loadThemeMode();
  }

  ThemeMode get themeMode => _themeMode;

  void _loadThemeMode() {
    final savedMode = prefs.getString(_themeKey);
    _themeMode = savedMode == 'dark'
        ? ThemeMode.dark
        : savedMode == 'light'
            ? ThemeMode.light
            : ThemeMode.system;
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    await prefs.setString(
        _themeKey,
        mode == ThemeMode.dark
            ? 'dark'
            : mode == ThemeMode.light
                ? 'light'
                : 'system');
    notifyListeners();
  }
}
