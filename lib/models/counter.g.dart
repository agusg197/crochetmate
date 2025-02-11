// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'counter.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CounterAdapter extends TypeAdapter<Counter> {
  @override
  final int typeId = 2;

  @override
  Counter read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Counter(
      id: fields[0] as String,
      name: fields[1] as String,
      count: fields[2] as int,
      isRunning: fields[3] as bool,
      startTime: fields[4] as DateTime?,
      lastUpdateTime: fields[5] as DateTime?,
      history: (fields[6] as List).cast<CounterHistoryItem>(),
    );
  }

  @override
  void write(BinaryWriter writer, Counter obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.count)
      ..writeByte(3)
      ..write(obj.isRunning)
      ..writeByte(4)
      ..write(obj.startTime)
      ..writeByte(5)
      ..write(obj.lastUpdateTime)
      ..writeByte(6)
      ..write(obj.history);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CounterAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
