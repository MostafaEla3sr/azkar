// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MorningNotificationAdapter extends TypeAdapter<MorningNotification> {
  @override
  final int typeId = 0;

  @override
  MorningNotification read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MorningNotification(
      isAllowed: fields[0] as bool,
      startTime: fields[1] as DateTime,
      endTime: fields[2] as int,
      intervalTime: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, MorningNotification obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.isAllowed)
      ..writeByte(1)
      ..write(obj.startTime)
      ..writeByte(2)
      ..write(obj.endTime)
      ..writeByte(3)
      ..write(obj.intervalTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MorningNotificationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class EveningNotificationAdapter extends TypeAdapter<EveningNotification> {
  @override
  final int typeId = 1;

  @override
  EveningNotification read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EveningNotification(
      isAllowed: fields[0] as bool,
      startTime: fields[1] as DateTime,
      endTime: fields[2] as int,
      intervalTime: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, EveningNotification obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.isAllowed)
      ..writeByte(1)
      ..write(obj.startTime)
      ..writeByte(2)
      ..write(obj.endTime)
      ..writeByte(3)
      ..write(obj.intervalTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EveningNotificationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
