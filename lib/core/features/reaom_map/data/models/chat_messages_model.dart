class ChatMessageModel {
  final String content;
  final bool isUser;
  final String senderName;
  final String senderAvatar;

  ChatMessageModel({
    required this.content,
    required this.isUser,
    required this.senderName,
    required this.senderAvatar,
  });

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'isUser': isUser,
      'senderName': senderName,
      'senderAvatar': senderAvatar,
    };
  }

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      content: json['content'],
      isUser: json['isUser'],
      senderName: json['senderName'],
      senderAvatar: json['senderAvatar'],
    );
  }
}

class SavedChatSession {
  final List<ChatMessageModel> messages;
  final String title;
  final DateTime timestamp;

  SavedChatSession({
    required this.messages,
    required this.title,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'messages': messages.map((m) => m.toJson()).toList(),
      'title': title,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory SavedChatSession.fromJson(Map<String, dynamic> json) {
    return SavedChatSession(
      messages: (json['messages'] as List)
          .map((m) => ChatMessageModel.fromJson(m as Map<String, dynamic>))
          .toList(),
      title: json['title'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }
}