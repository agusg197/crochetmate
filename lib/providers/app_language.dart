import 'package:flutter/material.dart';

class AppLanguage extends InheritedWidget {
  final String currentLanguage;
  final Function(String) onChangeLanguage;
  final Map<String, String> translations;

  const AppLanguage({
    super.key,
    required this.currentLanguage,
    required this.onChangeLanguage,
    required this.translations,
    required super.child,
  });

  static AppLanguage of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<AppLanguage>();
    assert(result != null, 'No AppLanguage found in context');
    return result!;
  }

  String translate(String key) {
    return translations[key] ?? key;
  }

  @override
  bool updateShouldNotify(AppLanguage oldWidget) {
    return currentLanguage != oldWidget.currentLanguage ||
        translations != oldWidget.translations;
  }
}
