class ChatMessage {
  final String from;
  final String text;
  final bool isUser;
  final DateTime? timestamp;

  ChatMessage(
      {required this.from,
      required this.text,
      this.isUser = false,
      this.timestamp});

  Map<String, dynamic> toMap() {
    return {
      'from': from,
      'text': text,
      'isUser': isUser,
      'timestamp': timestamp?.toIso8601String(),
    };
  }

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      from: map['from'] ?? 'Unknown',
      text: map['text'] ?? '',
      isUser: map['isUser'] ?? false,
      timestamp:
          map['timestamp'] != null ? DateTime.parse(map['timestamp']) : null,
    );
  }
}
