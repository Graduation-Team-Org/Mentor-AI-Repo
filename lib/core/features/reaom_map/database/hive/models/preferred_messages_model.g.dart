// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preferred_messages_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PreferredMessagesModelAdapter
    extends TypeAdapter<PreferredMessagesModel> {
  @override
  final int typeId = 0;

  @override
  PreferredMessagesModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PreferredMessagesModel(
      msgContent: fields[0] as String,
      msgImage: fields[1] as String,
      likeDate: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PreferredMessagesModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.msgContent)
      ..writeByte(1)
      ..write(obj.msgImage)
      ..writeByte(2)
      ..write(obj.likeDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PreferredMessagesModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
