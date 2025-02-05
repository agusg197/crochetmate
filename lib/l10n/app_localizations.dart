import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'app_name': 'CrochetMate',
      'app_subtitle': 'Your crochet companion',
      'my_projects': 'My Projects',
      'manage_projects': 'Manage your projects',
      'patterns': 'Patterns',
      'explore_patterns': 'Explore patterns',
      'counters': 'Counters',
      'count_rounds': 'Count your rounds',
      'settings': 'Settings',
      'customize_app': 'Customize the app',
      'theme': 'Theme',
      'language': 'Language',
      'system': 'System',
      'light': 'Light',
      'dark': 'Dark',
      'spanish': 'Spanish',
      'english': 'English',
      'select_theme': 'Select theme',
      'select_language': 'Select language',
    },
    'es': {
      'app_name': 'CrochetMate',
      'app_subtitle': 'Tu compañero de crochet',
      'my_projects': 'Mis Proyectos',
      'manage_projects': 'Gestiona tus proyectos',
      'patterns': 'Patrones',
      'explore_patterns': 'Explora patrones',
      'counters': 'Contadores',
      'count_rounds': 'Cuenta tus vueltas',
      'settings': 'Ajustes',
      'customize_app': 'Personaliza la app',
      'theme': 'Tema',
      'language': 'Idioma',
      'system': 'Sistema',
      'light': 'Claro',
      'dark': 'Oscuro',
      'spanish': 'Español',
      'english': 'Inglés',
      'select_theme': 'Seleccionar tema',
      'select_language': 'Seleccionar idioma',
    },
  };

  String get(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? key;
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['es', 'en'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
