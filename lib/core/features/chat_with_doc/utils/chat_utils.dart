import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/chat_message.dart';

class ChatUtils {
  static Future<List<String>> getChatHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('chat_metadata') ?? [];
  }

  static Future<void> saveChatHistory(List<String> history) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('chat_metadata', history);
  }

  static Future<void> saveConversation(
    String conversationName,
    List<ChatMessage> messages,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String encodedMessages = jsonEncode(
      messages.map((msg) => msg.toMap()).toList(),
    );
    await prefs.setString(conversationName, encodedMessages);
  }

  static Future<List<ChatMessage>> loadConversation(
    String conversationName,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? encodedMessages = prefs.getString(conversationName);

    if (encodedMessages != null) {
      List<dynamic> decodedMessages = jsonDecode(encodedMessages);
      return decodedMessages
          .map((msg) => ChatMessage.fromMap(Map<String, String>.from(msg)))
          .toList();
    }
    return [];
  }

  static String generateConversationName(String firstQuestion) {
    // Clean and format the question to create a suitable name
    String cleanQuestion = firstQuestion.trim();

    // If the question is too long, truncate it
    if (cleanQuestion.length > 30) {
      cleanQuestion = cleanQuestion.substring(0, 27) + '...';
    }

    // Add timestamp to ensure uniqueness
    String timestamp = DateTime.now().toString().split('.')[0];

    return '$cleanQuestion ($timestamp)';
  }

  static String getDisplayName(String conversationName) {
    // Remove the timestamp from the display name
    if (conversationName.contains(' (')) {
      return conversationName.substring(0, conversationName.lastIndexOf(' ('));
    }
    return conversationName;
  }
}
