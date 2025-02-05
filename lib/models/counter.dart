import 'counter_history_item.dart';

class Counter {
  final String id;
  String name;
  int count;
  List<CounterHistoryItem> history;
  DateTime? startTime;
  DateTime? lastUpdateTime;
  bool isRunning;

  Counter({
    required this.id,
    required this.name,
    this.count = 0,
    this.history = const [],
    this.startTime,
    this.lastUpdateTime,
    this.isRunning = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'count': count,
      'history': history.map((item) => item.toJson()).toList(),
      'startTime': startTime?.toIso8601String(),
      'lastUpdateTime': lastUpdateTime?.toIso8601String(),
      'isRunning': isRunning,
    };
  }

  factory Counter.fromJson(Map<String, dynamic> json) {
    return Counter(
      id: json['id'],
      name: json['name'],
      count: json['count'],
      history: (json['history'] as List)
          .map((item) => CounterHistoryItem.fromJson(item))
          .toList(),
      startTime:
          json['startTime'] != null ? DateTime.parse(json['startTime']) : null,
      lastUpdateTime: json['lastUpdateTime'] != null
          ? DateTime.parse(json['lastUpdateTime'])
          : null,
      isRunning: json['isRunning'],
    );
  }

  double get averageTimePerRound {
    if (history.length < 2) return 0;
    final totalDuration =
        history.first.timestamp.difference(history.last.timestamp).inSeconds;
    return totalDuration / (history.length - 1);
  }
}
