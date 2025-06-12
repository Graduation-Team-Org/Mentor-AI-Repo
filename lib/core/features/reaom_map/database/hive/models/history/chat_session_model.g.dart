// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_session_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChatSessionModelAdapter extends TypeAdapter<ChatSessionModel> {
  @override
  final int typeId = 1;

  @override
  ChatSessionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChatSessionModel(
      sessionId: fields[0] as String,
      sessionTitle: fields[1] as String,
      messageContent: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ChatSessionModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.sessionId)
      ..writeByte(1)
      ..write(obj.sessionTitle)
      ..writeByte(2)
      ..write(obj.messageContent);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatSessionModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
