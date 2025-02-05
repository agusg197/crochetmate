import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/pattern.dart';

class PatternService {
  static const String _patternsKey = 'patterns';
  final SharedPreferences _prefs;

  PatternService(this._prefs);

  Future<List<Pattern>> getPatterns() async {
    final String? data = _prefs.getString(_patternsKey);
    if (data == null) return [];

    final List<dynamic> jsonList = json.decode(data);
    return jsonList.map((json) => Pattern.fromJson(json)).toList();
  }

  Future<void> savePattern(Pattern pattern) async {
    final patterns = await getPatterns();
    final index = patterns.indexWhere((p) => p.id == pattern.id);

    if (index >= 0) {
      patterns[index] = pattern;
    } else {
      patterns.add(pattern);
    }

    await _savePatterns(patterns);
  }

  Future<void> deletePattern(String id) async {
    final patterns = await getPatterns();
    patterns.removeWhere((p) => p.id == id);
    await _savePatterns(patterns);
  }

  Future<List<Pattern>> searchPatterns(String query,
      {String? difficulty}) async {
    final patterns = await getPatterns();
    return patterns.where((pattern) {
      final matchesQuery = query.isEmpty ||
          pattern.name.toLowerCase().contains(query.toLowerCase()) ||
          pattern.description.toLowerCase().contains(query.toLowerCase());

      final matchesDifficulty =
          difficulty == null || pattern.difficulty == difficulty;

      return matchesQuery && matchesDifficulty;
    }).toList();
  }

  Future<void> _savePatterns(List<Pattern> patterns) async {
    final String data = json.encode(patterns.map((p) => p.toJson()).toList());
    await _prefs.setString(_patternsKey, data);
  }
}
