import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:road_map_mentor/core/features/cv_analysis/data/repos/road_map_repos.dart';
import 'package:road_map_mentor/core/features/reaom_map/data/models/chat_messages_model.dart';
import 'package:road_map_mentor/core/features/reaom_map/data/repos/road_map_repos_imp.dart';
import 'package:road_map_mentor/core/features/reaom_map/services/chat_session_service.dart';

part 'add_messages_state.dart';

class AnalyzeReumeAllMessagesCubit extends Cubit<AllMessagesState> {
  final AnalyzeResumeRepos _analyzeResumeRepos;
  List<ChatMessageModel> messages = [];
  String? currentSessionId;

  AnalyzeReumeAllMessagesCubit(this._analyzeResumeRepos)
      : super(AllMessagesInitial());

  Future<void> addmessage(
      {required String content, required BuildContext context}) async {
    try {
      // Get and emit user message immediately
      final newMessages = await _analyzeResumeRepos.addMessage(content);
      messages = newMessages;
      emit(AllMessagesScussess(chatMessagesModel: List.from(messages)));

      // Start listening for assistant's response
      _listenForAssistantResponse(context);
    } catch (e) {
      emit(AllMessagesFailure(errorMessage: e.toString()));
    }
  }

  Future<void> _listenForAssistantResponse(BuildContext context) async {
    try {
      // Poll for new messages
      for (int i = 0; i < 10; i++) {
        final assistantMessages =
            await (_analyzeResumeRepos as RoadMapReposImp).getMessages();

        if (assistantMessages.length > messages.length) {
          // We have new messages from the assistant
          messages = assistantMessages;
          emit(AllMessagesScussess(chatMessagesModel: List.from(messages)));

          // Save chat session after receiving response
          if (messages.length >= 2) {
            // At least one user message and one response
            currentSessionId =
                await ChatSessionService.saveChatSession(messages);
          }

          break;
        }
        // emit(AllMessagesLoading());

        await Future.delayed(const Duration(seconds: 1));
      }
    } catch (e) {
      print("Error getting assistant response: $e");
    }
  }

  // Load a specific chat session
  Future<void> loadChatSession(String sessionId) async {
    try {
      final sessionData = await ChatSessionService.getChatSession(sessionId);
      if (sessionData != null) {
        final List<dynamic> messagesJson = sessionData['messages'];
        final loadedMessages = messagesJson
            .map((json) => ChatMessageModel.fromJson(json))
            .toList();

        messages = loadedMessages;
        currentSessionId = sessionId;
        emit(AllMessagesScussess(chatMessagesModel: List.from(messages)));
      }
    } catch (e) {
      emit(AllMessagesFailure(errorMessage: e.toString()));
    }
  }
}
