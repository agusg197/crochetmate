import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/counter.dart';

class CounterService {
  static const String _countersKey = 'counters';
  final SharedPreferences _prefs;

  CounterService(this._prefs);

  Future<List<Counter>> getCounters() async {
    final String? data = _prefs.getString(_countersKey);
    if (data == null) return [];

    final List<dynamic> jsonList = json.decode(data);
    return jsonList.map((json) => Counter.fromJson(json)).toList();
  }

  Future<void> saveCounter(Counter counter) async {
    final counters = await getCounters();
    final index = counters.indexWhere((c) => c.id == counter.id);

    if (index >= 0) {
      counters[index] = counter;
    } else {
      counters.add(counter);
    }

    await _saveCounters(counters);
  }

  Future<void> deleteCounter(String id) async {
    final counters = await getCounters();
    counters.removeWhere((counter) => counter.id == id);
    await _saveCounters(counters);
  }

  Future<void> _saveCounters(List<Counter> counters) async {
    final String data = json.encode(
      counters.map((counter) => counter.toJson()).toList(),
    );
    await _prefs.setString(_countersKey, data);
  }
}
