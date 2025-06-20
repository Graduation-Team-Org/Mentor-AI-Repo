// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preferred_messages_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PreferredAnalyzeResumeMessagesModelAdapter
    extends TypeAdapter<PreferredAnalyzeResumeMessagesModel> {
  @override
  final int typeId = 0;

  @override
  PreferredAnalyzeResumeMessagesModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PreferredAnalyzeResumeMessagesModel(
      msgContent: fields[0] as String,
      msgImage: fields[1] as String,
      likeDate: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PreferredAnalyzeResumeMessagesModel obj) {
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
      other is PreferredAnalyzeResumeMessagesModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
