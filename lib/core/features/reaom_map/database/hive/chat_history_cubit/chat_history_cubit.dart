import 'package:bloc/bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:meta/meta.dart';
import 'package:road_map_mentor/core/features/reaom_map/data/models/chat_messages_model.dart';
import 'package:road_map_mentor/core/features/reaom_map/database/hive/constants/hive_constants.dart';
import 'package:road_map_mentor/core/features/reaom_map/database/hive/models/history/chat_session_model.dart';
import 'package:uuid/uuid.dart';
part 'chat_history_state.dart';

class ChatHistoryCubit extends Cubit<ChatHistoryState> {
  ChatHistoryCubit() : super(ChatHistoryInitial()) {
    // Load saved chat sessions when cubit is created
    getAllChatSessions();
  }
  
  // List to keep track of chat sessions
  List<ChatSessionModel> chatSessions = [];
  
  // Get all chat sessions
  Future<void> getAllChatSessions() async {
    try {
      emit(ChatHistoryLoading());
      
      var chatSessionsBox = Hive.box<ChatSessionModel>(kChatSessions);
      chatSessions = chatSessionsBox.values.toList();
      
      // Sort by creation date (newest first)
      chatSessions.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      
      emit(ChatHistorySuccess(chatSessions: chatSessions));
    } catch (e) {
      emit(ChatHistoryFailure(errorMessage: e.toString()));
    }
  }
  
  // Save a new chat session
  Future<void> saveChatSession(List<ChatMessageModel> messages, {String? title}) async {
    try {
      emit(ChatHistoryLoading());
      
      // Generate a title if not provided
      final sessionTitle = title ?? 
          (messages.isNotEmpty ? messages.first.content.substring(0, 
              messages.first.content.length > 30 ? 30 : messages.first.content.length) : 'New Chat');
      
      // Create a new chat session
      final sessionId = const Uuid().v4();
      final chatSession = ChatSessionModel(
        sessionId: sessionId,
        sessionTitle: sessionTitle,
        messages: messages,
      );
      
      // Save to Hive
      var chatSessionsBox = Hive.box<ChatSessionModel>(kChatSessions);
      await chatSessionsBox.put(sessionId, chatSession);
      
      // Update our local list
      await getAllChatSessions();
    } catch (e) {
      emit(ChatHistoryFailure(errorMessage: e.toString()));
    }
  }
  
  // Delete a chat session
  Future<void> deleteChatSession(String sessionId) async {
    try {
      emit(ChatHistoryLoading());
      
      // Delete from Hive
      var chatSessionsBox = Hive.box<ChatSessionModel>(kChatSessions);
      await chatSessionsBox.delete(sessionId);
      
      // Update our local list
      await getAllChatSessions();
    } catch (e) {
      emit(ChatHistoryFailure(errorMessage: e.toString()));
    }
  }
  
  // Load a chat session
  ChatSessionModel? getChatSession(String sessionId) {
    try {
      var chatSessionsBox = Hive.box<ChatSessionModel>(kChatSessions);
      return chatSessionsBox.get(sessionId);
    } catch (e) {
      emit(ChatHistoryFailure(errorMessage: e.toString()));
      return null;
    }
  }
}