// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pattern.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PatternAdapter extends TypeAdapter<Pattern> {
  @override
  final int typeId = 3;

  @override
  Pattern read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Pattern(
      id: fields[0] as String,
      name: fields[1] as String,
      description: fields[2] as String,
      difficulty: fields[3] as String,
      instructions: fields[4] as String,
      images: (fields[5] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, Pattern obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.difficulty)
      ..writeByte(4)
      ..write(obj.instructions)
      ..writeByte(5)
      ..write(obj.images);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PatternAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
