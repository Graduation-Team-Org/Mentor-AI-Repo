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
