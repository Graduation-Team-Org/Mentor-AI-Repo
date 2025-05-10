import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:road_map_mentor/core/features/reaom_map/data/models/chat_messages_model.dart';
import 'package:road_map_mentor/core/features/reaom_map/data/repos/road_map_repos.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'saved_all_messages_state.dart';

class SavedAllMessagesCubit extends Cubit<SavedAllMessagesState> {
  final RoadMapRepos roadMapRepos;
  List<SavedChatSession> savedSessions = [];
  static const String _storageKey = 'saved_chat_sessions';

  SavedAllMessagesCubit(this.roadMapRepos) : super(SavedAllMessagesInitial()) {
    _loadSavedSessions();
  }

  Future<void> _loadSavedSessions() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? jsonString = prefs.getString(_storageKey);
      
      if (jsonString != null) {
        final List<dynamic> jsonList = jsonDecode(jsonString);
        savedSessions = jsonList
            .map((json) => SavedChatSession.fromJson(json))
            .toList();
        print('Loaded ${savedSessions.length} sessions from storage');
        emit(SavedAllMessagesSuccess(savedSessions: savedSessions));
      } else {
        emit(SavedAllMessagesSuccess(savedSessions: []));
      }
    } catch (e) {
      print('Error loading saved sessions: $e');
      emit(SavedAllMessagesSuccess(savedSessions: []));
    }
  }

  Future<void> saveCurrentSession({
    required List<ChatMessageModel> messages,
    required String title,
  }) async {
    try {
      print('Saving new session with title: $title');
      final newSession = SavedChatSession(
        messages: messages,
        title: title,
        timestamp: DateTime.now(),
      );
      
      savedSessions = [...savedSessions, newSession];
      print('Total sessions after save: ${savedSessions.length}');
      
      // Save to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final jsonString = jsonEncode(
        savedSessions.map((s) => s.toJson()).toList()
      );
      await prefs.setString(_storageKey, jsonString);
      print('Sessions saved to storage');
      
      emit(SavedAllMessagesSuccess(savedSessions: savedSessions));
    } catch (e) {
      print('Error saving session: $e');
    }
  }

  void loadSession(String title) {
    try {
      final session = savedSessions.firstWhere((s) => s.title == title);
      emit(SavedSessionLoaded(messages: session.messages));
    } catch (e) {
      print('Session not found: $e');
    }
  }
}
