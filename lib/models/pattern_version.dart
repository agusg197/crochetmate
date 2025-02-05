class PatternVersion {
  final String id;
  final String patternId;
  final String content;
  final String description;
  final DateTime createdAt;
  final int versionNumber;

  PatternVersion({
    required this.id,
    required this.patternId,
    required this.content,
    required this.description,
    required this.createdAt,
    required this.versionNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patternId': patternId,
      'content': content,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'versionNumber': versionNumber,
    };
  }

  factory PatternVersion.fromJson(Map<String, dynamic> json) {
    return PatternVersion(
      id: json['id'],
      patternId: json['patternId'],
      content: json['content'],
      description: json['description'],
      createdAt: DateTime.parse(json['createdAt']),
      versionNumber: json['versionNumber'],
    );
  }
}
