class Round {
  final String id;
  int number;
  String instructions;
  bool isCompleted;
  int stitchCount;
  String? notes;

  Round({
    required this.id,
    required this.number,
    required this.instructions,
    this.isCompleted = false,
    this.stitchCount = 0,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'number': number,
      'instructions': instructions,
      'isCompleted': isCompleted,
      'stitchCount': stitchCount,
      'notes': notes,
    };
  }

  factory Round.fromJson(Map<String, dynamic> json) {
    return Round(
      id: json['id'],
      number: json['number'],
      instructions: json['instructions'],
      isCompleted: json['isCompleted'],
      stitchCount: json['stitchCount'],
      notes: json['notes'],
    );
  }
}
