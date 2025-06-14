import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import '../models/chat_message.dart';

class ChatSharingService {
  static const String _baseUrl =
      'https://hppkxmfqp7.us-east-1.awsapprunner.com'; // Deployed App Runner Flask server

  // Share a chat and get a unique URL
  static Future<String> shareChat(List<ChatMessage> messages) async {
    try {
      final response = await http
          .post(
        Uri.parse('$_baseUrl/share-chat'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'messages': messages.map((msg) => msg.toMap()).toList(),
          'expires_at': DateTime.now()
              .add(Duration(days: 30))
              .toIso8601String(), // 30 days expiry
        }),
      )
          .timeout(
        Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException(
              'Connection timed out. Please check your internet connection and try again.');
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['share_url'];
      } else if (response.statusCode == 503) {
        throw Exception(
            'The sharing service is currently unavailable. Please try again later.');
      } else {
        throw Exception('Failed to share chat. Please try again.');
      }
    } on TimeoutException {
      throw Exception(
          'Connection timed out. Please check your internet connection and try again.');
    } on SocketException {
      throw Exception(
          'Unable to connect to the sharing service. Please check your internet connection.');
    } catch (e) {
      throw Exception('Failed to share chat. Please try again later.');
    }
  }

  // Fetch a shared chat
  static Future<List<ChatMessage>> fetchSharedChat(String chatId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/shared-chat/$chatId'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return (data['messages'] as List)
            .map((msg) => ChatMessage.fromMap(Map<String, String>.from(msg)))
            .toList();
      } else {
        throw Exception('Failed to fetch shared chat: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching shared chat: $e');
    }
  }

  // Delete a shared chat
  static Future<void> deleteSharedChat(String chatId) async {
    try {
      final response = await http.delete(
        Uri.parse('$_baseUrl/shared-chat/$chatId'),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to delete shared chat: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error deleting shared chat: $e');
    }
  }

  /// Get chat metadata without full content
  static Future<Map<String, dynamic>> getChatMetadata(String chatId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/shared-chat/$chatId'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'title': data['title'] ?? 'Shared Chat',
          'created_at': data['created_at'],
          'expires_at': data['expires_at'],
          'message_count': (data['messages'] as List).length,
        };
      } else {
        throw Exception('Failed to fetch chat metadata');
      }
    } catch (e) {
      throw Exception('Network error: ${e.toString()}');
    }
  }
}
