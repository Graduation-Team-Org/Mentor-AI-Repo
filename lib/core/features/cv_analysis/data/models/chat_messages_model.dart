class AnalyzeResumeChatMessageModel {
  final String content;
  final bool isUser;
  final String senderName;
  final String senderAvatar;

  AnalyzeResumeChatMessageModel({
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

  factory AnalyzeResumeChatMessageModel.fromJson(Map<String, dynamic> json) {
    return AnalyzeResumeChatMessageModel(
      content: json['content'],
      isUser: json['isUser'],
      senderName: json['senderName'],
      senderAvatar: json['senderAvatar'],
    );
  }
}
