import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:road_map_mentor/core/features/reaom_map/data/models/chat_messages_model.dart';
import 'package:uuid/uuid.dart';

class ChatSessionService {
  static const String _sessionsKey = 'chat_sessions';
  static const String _sessionIdsKey = 'chat_session_ids';
  
  // Save a chat session
  static Future<String> saveChatSession(List<ChatMessageModel> messages) async {
    if (messages.isEmpty) return '';
    
    final prefs = await SharedPreferences.getInstance();
    
    // Generate a unique session ID
    final sessionId = const Uuid().v4();
    
    // Create session title from first message content (truncated)
    final firstMessage = messages.first;
    final sessionTitle = firstMessage.content.length > 30
        ? '${firstMessage.content.substring(0, 30)}...'
        : firstMessage.content;
    
    // Convert messages to JSON
    final messagesJson = messages.map((msg) => msg.toJson()).toList();
    
    // Create session data
    final sessionData = {
      'sessionId': sessionId,
      'sessionTitle': sessionTitle,
      'messages': messagesJson,
      'createdAt': DateTime.now().toIso8601String(),
    };
    
    // Save session data
    await prefs.setString('session_$sessionId', jsonEncode(sessionData));
    
    // Update session IDs list
    List<String> sessionIds = prefs.getStringList(_sessionIdsKey) ?? [];
    sessionIds.add(sessionId);
    await prefs.setStringList(_sessionIdsKey, sessionIds);
    
    return sessionId;
  }
  
  // Get all chat sessions
  static Future<List<Map<String, dynamic>>> getAllChatSessions() async {
    final prefs = await SharedPreferences.getInstance();
    final sessionIds = prefs.getStringList(_sessionIdsKey) ?? [];
    
    List<Map<String, dynamic>> sessions = [];
    
    for (final id in sessionIds) {
      final sessionJson = prefs.getString('session_$id');
      if (sessionJson != null) {
        sessions.add(jsonDecode(sessionJson));
      }
    }
    
    // Sort by creation date (newest first)
    sessions.sort((a, b) {
      final dateA = DateTime.parse(a['createdAt']);
      final dateB = DateTime.parse(b['createdAt']);
      return dateB.compareTo(dateA);
    });
    
    return sessions;
  }
  
  // Get a specific chat session
  static Future<Map<String, dynamic>?> getChatSession(String sessionId) async {
    final prefs = await SharedPreferences.getInstance();
    final sessionJson = prefs.getString('session_$sessionId');
    
    if (sessionJson != null) {
      return jsonDecode(sessionJson);
    }
    
    return null;
  }
  
  // Delete a chat session
  static Future<bool> deleteChatSession(String sessionId) async {
    final prefs = await SharedPreferences.getInstance();
    
    // Remove session data
    await prefs.remove('session_$sessionId');
    
    // Update session IDs list
    List<String> sessionIds = prefs.getStringList(_sessionIdsKey) ?? [];
    sessionIds.remove(sessionId);
    await prefs.setStringList(_sessionIdsKey, sessionIds);
    
    return true;
  }
}