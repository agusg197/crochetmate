// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProjectAdapter extends TypeAdapter<Project> {
  @override
  final int typeId = 0;

  @override
  Project read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Project(
      id: fields[0] as String,
      name: fields[1] as String,
      description: fields[2] as String,
      images: (fields[3] as List).cast<String>(),
      rounds: (fields[4] as List).cast<Round>(),
      status: fields[5] as ProjectStatus,
      createdAt: fields[6] as DateTime,
      updatedAt: fields[7] as DateTime?,
      notes: fields[8] as String?,
      hookSize: fields[9] as String?,
      yarnType: fields[10] as String?,
      deadline: fields[11] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Project obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.images)
      ..writeByte(4)
      ..write(obj.rounds)
      ..writeByte(5)
      ..write(obj.status)
      ..writeByte(6)
      ..write(obj.createdAt)
      ..writeByte(7)
      ..write(obj.updatedAt)
      ..writeByte(8)
      ..write(obj.notes)
      ..writeByte(9)
      ..write(obj.hookSize)
      ..writeByte(10)
      ..write(obj.yarnType)
      ..writeByte(11)
      ..write(obj.deadline);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProjectAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ProjectStatusAdapter extends TypeAdapter<ProjectStatus> {
  @override
  final int typeId = 1;

  @override
  ProjectStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ProjectStatus.notStarted;
      case 1:
        return ProjectStatus.inProgress;
      case 2:
        return ProjectStatus.completed;
      case 3:
        return ProjectStatus.onHold;
      default:
        return ProjectStatus.notStarted;
    }
  }

  @override
  void write(BinaryWriter writer, ProjectStatus obj) {
    switch (obj) {
      case ProjectStatus.notStarted:
        writer.writeByte(0);
        break;
      case ProjectStatus.inProgress:
        writer.writeByte(1);
        break;
      case ProjectStatus.completed:
        writer.writeByte(2);
        break;
      case ProjectStatus.onHold:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProjectStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
