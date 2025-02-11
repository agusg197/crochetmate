import 'package:hive/hive.dart';

part 'pattern.g.dart';

@HiveType(typeId: 3)
class Pattern extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String description;

  @HiveField(3)
  String difficulty;

  @HiveField(4)
  String instructions;

  @HiveField(5)
  List<String> images;

  Pattern({
    required this.id,
    required this.name,
    this.description = '',
    this.difficulty = 'beginner',
    this.instructions = '',
    this.images = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'difficulty': difficulty,
      'instructions': instructions,
      'images': images,
    };
  }

  factory Pattern.fromJson(Map<String, dynamic> json) {
    return Pattern(
      id: json['id'],
      name: json['name'],
      description: json['description'] ?? '',
      difficulty: json['difficulty'] ?? 'beginner',
      instructions: json['instructions'] ?? '',
      images: List<String>.from(json['images'] ?? []),
    );
  }
}
