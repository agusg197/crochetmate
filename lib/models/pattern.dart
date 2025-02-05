class Pattern {
  final String id;
  String name;
  String description;
  String difficulty;
  String content;
  final DateTime createdAt;
  DateTime? updatedAt;

  Pattern({
    required this.id,
    required this.name,
    this.description = '',
    required this.difficulty,
    required this.content,
    required this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'difficulty': difficulty,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory Pattern.fromJson(Map<String, dynamic> json) {
    return Pattern(
      id: json['id'],
      name: json['name'],
      description: json['description'] ?? '',
      difficulty: json['difficulty'],
      content: json['content'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }
}
