part of 'saved_all_messages_cubit.dart';

abstract class SavedAllMessagesState {}

class SavedAllMessagesInitial extends SavedAllMessagesState {}

class SavedAllMessagesSuccess extends SavedAllMessagesState {
  final List<SavedChatSession> savedSessions;

  SavedAllMessagesSuccess({required this.savedSessions});
}

class SavedSessionLoaded extends SavedAllMessagesState {
  final List<ChatMessageModel> messages;

  SavedSessionLoaded({required this.messages});
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
          .map((m) => ChatMessageModel.fromJson(m))
          .toList(),
      title: json['title'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}

