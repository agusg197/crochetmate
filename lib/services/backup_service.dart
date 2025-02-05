import 'dart:convert';

import 'package:path_provider/path_provider.dart';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

class BackupService {
  final SharedPreferences _prefs;

  BackupService(this._prefs);

  Future<String> createBackup() async {
    final data = {
      'patterns': _prefs.getString('patterns'),
      'projects': _prefs.getString('projects'),
      'counters': _prefs.getString('counters'),
      'timestamp': DateTime.now().toIso8601String(),
    };

    final directory = await getApplicationDocumentsDirectory();
    final file = File(
        '${directory.path}/backup_${DateTime.now().millisecondsSinceEpoch}.json');

    await file.writeAsString(json.encode(data));
    return file.path;
  }

  Future<bool> restoreBackup(String path) async {
    try {
      final file = File(path);
      final data = json.decode(await file.readAsString());

      await _prefs.setString('patterns', data['patterns'] ?? '[]');
      await _prefs.setString('projects', data['projects'] ?? '[]');
      await _prefs.setString('counters', data['counters'] ?? '[]');

      return true;
    } catch (e) {
      return false;
    }
  }
}
