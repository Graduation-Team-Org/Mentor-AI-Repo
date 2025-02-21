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
}