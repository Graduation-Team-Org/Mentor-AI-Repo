import 'package:hive/hive.dart';

part 'chat_session_model.g.dart';

@HiveType(typeId: 1) // Using typeId 1 since PreferredMessagesModel uses 0
class ChatSessionModel extends HiveObject {
  @HiveField(0)
  final String sessionId;

  @HiveField(1)
  final String sessionTitle;

  @HiveField(2)
  final String messageContent;

  ChatSessionModel({
    required this.sessionId,
    required this.sessionTitle,
    required this.messageContent,
  });
}

// flutter packages pub run build_runner build --build-filter="lib/core/features/reaom_map/database/hive/models/chat_session_model.dart" --delete-conflicting-outputs
