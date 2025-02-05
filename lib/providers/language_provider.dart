import 'package:flutter/material.dart';
import '../services/localization_service.dart';

class LanguageProvider extends ChangeNotifier {
  final LocalizationService _localizationService;
  String _currentLanguage = 'es';
  bool _isInitialized = false;

  LanguageProvider(this._localizationService) {
    _initLanguage();
  }

  String get currentLanguage => _currentLanguage;
  bool get isInitialized => _isInitialized;

  Future<void> _initLanguage() async {
    try {
      _currentLanguage = await _localizationService.getLanguage();
      _isInitialized = true;
      debugPrint('Language initialized: $_currentLanguage');
      notifyListeners();
    } catch (e) {
      debugPrint('Error initializing language: $e');
    }
  }

  Future<void> changeLanguage(String languageCode) async {
    try {
      debugPrint('Changing language to: $languageCode');
      await _localizationService.setLanguage(languageCode);
      _currentLanguage = languageCode;
      debugPrint('Language changed successfully');
      notifyListeners();
    } catch (e) {
      debugPrint('Error changing language: $e');
    }
  }

  Map<String, String> getAllTranslations() {
    return _localizationService.getAllTranslationsForLanguage(_currentLanguage);
  }

  String translate(String key) {
    return _localizationService.translate(key);
  }

  void toggleLanguage() {
    _currentLanguage = _currentLanguage == 'es' ? 'en' : 'es';
    _localizationService.setLanguage(_currentLanguage);
    notifyListeners();
  }
}
