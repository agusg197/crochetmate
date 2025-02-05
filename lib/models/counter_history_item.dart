class CounterHistoryItem {
  final String id;
  final DateTime timestamp;
  final int count;
  final String action;
  String? note;
  Duration? roundDuration;

  CounterHistoryItem({
    required this.id,
    required this.timestamp,
    required this.count,
    required this.action,
    this.note,
    this.roundDuration,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'timestamp': timestamp.toIso8601String(),
        'count': count,
        'action': action,
        'note': note,
        'roundDuration': roundDuration?.inSeconds,
      };

  factory CounterHistoryItem.fromJson(Map<String, dynamic> json) =>
      CounterHistoryItem(
        id: json['id'],
        timestamp: DateTime.parse(json['timestamp']),
        count: json['count'],
        action: json['action'],
        note: json['note'],
        roundDuration: json['roundDuration'] != null
            ? Duration(seconds: json['roundDuration'])
            : null,
      );
}
