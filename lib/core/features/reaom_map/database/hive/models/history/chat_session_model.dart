import 'package:hive/hive.dart';
import 'package:road_map_mentor/core/features/reaom_map/data/models/chat_messages_model.dart';

part 'chat_session_model.g.dart';

@HiveType(typeId: 1) // Using typeId 1 since PreferredMessagesModel uses 0
class ChatSessionModel extends HiveObject {
  @HiveField(0)
  late String sessionId;
  
  @HiveField(1)
  late String sessionTitle;
  
  @HiveField(2)
  late List<Map<String, dynamic>> messagesJson;
  
  @HiveField(3)
  late DateTime createdAt;
  
  // Transient field - not stored in Hive
  List<ChatMessageModel>? _messages;
  
  ChatSessionModel({
    required this.sessionId,
    required this.sessionTitle,
    required List<ChatMessageModel> messages,
    DateTime? createdAt,
  }) {
    messagesJson = messages.map((msg) => msg.toJson()).toList();
    this.createdAt = createdAt ?? DateTime.now();
    _messages = messages;
  }
  
  // Getter for messages that converts from JSON when needed
  List<ChatMessageModel> get messages {
    _messages ??= messagesJson.map((json) => ChatMessageModel.fromJson(json)).toList();
    return _messages!;
  }
}

// flutter packages pub run build_runner build --build-filter="lib/core/features/reaom_map/database/hive/models/chat_session_model.dart" --delete-conflicting-outputs
