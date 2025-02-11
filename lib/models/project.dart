import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'round.dart';

part 'project.g.dart';

@HiveType(typeId: 0)
class Project extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String description;

  @HiveField(3)
  List<String> images;

  @HiveField(4)
  List<Round> rounds;

  @HiveField(5)
  ProjectStatus status;

  @HiveField(6)
  DateTime createdAt;

  @HiveField(7)
  DateTime? updatedAt;

  @HiveField(8)
  String? notes;

  @HiveField(9)
  String? hookSize; // Tamaño del gancho

  @HiveField(10)
  String? yarnType; // Tipo de hilo

  @HiveField(11)
  DateTime? deadline; // Fecha límite opcional

  Project({
    required this.id,
    required this.name,
    this.description = '',
    this.images = const [],
    this.rounds = const [],
    this.status = ProjectStatus.notStarted,
    required this.createdAt,
    this.updatedAt,
    this.notes,
    this.hookSize,
    this.yarnType,
    this.deadline,
  });

  double get progress {
    if (rounds.isEmpty) return 0;
    final completed = rounds.where((round) => round.isCompleted).length;
    return completed / rounds.length;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'images': images,
      'rounds': rounds.map((round) => round.toJson()).toList(),
      'status': status.toString(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'notes': notes,
      'hookSize': hookSize,
      'yarnType': yarnType,
      'deadline': deadline?.toIso8601String(),
    };
  }

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      images: List<String>.from(json['images']),
      rounds: (json['rounds'] as List)
          .map((round) => Round.fromJson(round))
          .toList(),
      status: ProjectStatus.values.firstWhere(
        (e) => e.toString() == json['status'],
        orElse: () => ProjectStatus.inProgress,
      ),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      notes: json['notes'],
      hookSize: json['hookSize'],
      yarnType: json['yarnType'],
      deadline:
          json['deadline'] != null ? DateTime.parse(json['deadline']) : null,
    );
  }
}

@HiveType(typeId: 1)
enum ProjectStatus {
  @HiveField(0)
  notStarted,

  @HiveField(1)
  inProgress,

  @HiveField(2)
  completed,

  @HiveField(3)
  onHold
}

extension ProjectStatusExtension on ProjectStatus {
  String get displayName {
    switch (this) {
      case ProjectStatus.notStarted:
        return 'No iniciado';
      case ProjectStatus.inProgress:
        return 'En progreso';
      case ProjectStatus.completed:
        return 'Completado';
      case ProjectStatus.onHold:
        return 'En pausa';
    }
  }

  Color get color {
    switch (this) {
      case ProjectStatus.notStarted:
        return Colors.grey;
      case ProjectStatus.inProgress:
        return Colors.blue;
      case ProjectStatus.completed:
        return Colors.green;
      case ProjectStatus.onHold:
        return Colors.orange;
    }
  }
}
