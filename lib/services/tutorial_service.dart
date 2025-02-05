import 'package:shared_preferences/shared_preferences.dart';

class TutorialService {
  static const String _hasSeenTutorialKey = 'has_seen_tutorial';
  final SharedPreferences _prefs;

  TutorialService(this._prefs);

  Future<bool> shouldShowTutorial() async {
    final hasSeenTutorial = _prefs.getBool(_hasSeenTutorialKey);
    return hasSeenTutorial == null || !hasSeenTutorial;
  }

  Future<void> markTutorialAsComplete() async {
    await _prefs.setBool(_hasSeenTutorialKey, true);
  }

  Future<void> resetTutorial() async {
    await _prefs.setBool(_hasSeenTutorialKey, false);
  }
}
