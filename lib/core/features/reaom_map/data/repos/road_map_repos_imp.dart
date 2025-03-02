import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:road_map_mentor/core/constants/constants.dart';
import 'package:road_map_mentor/core/errors/dio_erros.dart';
import 'package:road_map_mentor/core/features/reaom_map/data/models/chat_messages_model.dart';
import 'package:road_map_mentor/core/features/reaom_map/data/repos/road_map_repos.dart';
import 'package:road_map_mentor/core/features/reaom_map/database/preferences/shared_preferences.dart';
import 'package:road_map_mentor/core/features/reaom_map/functions/fun.dart';
import 'package:road_map_mentor/core/features/reaom_map/utils/services/custom_gpt_api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dartz/dartz.dart';

class RoadMapReposImp extends RoadMapRepos {
  SharedPreferences? preferences;
  String? threadId;

  List<ChatMessageModel> messages = [];
  final ScrollController _scrollController = ScrollController();

  RoadMapReposImp({
    this.preferences,
  });

  set setPreferences(SharedPreferences prefs) {
    preferences = prefs;
  }

  List<ChatMessageModel> retrunMessages() {
    return messages.isNotEmpty
        ? [
            ChatMessageModel(
              content: messages.first.content,
              isUser: messages.first.isUser,
              senderName: messages.first.senderName,
              senderAvatar: messages.first.senderAvatar,
            ),
          ]
        : [
            ChatMessageModel(
              content: 'No Content',
              isUser: true,
              senderName: 'No sender name',
              senderAvatar: 'assets/images/me.jpg',
            ),
          ];
  }

  Future<bool> isThreadEmpty(String threadId) async {
    try {
      final response = await CustomGptApiService()
          .get(endPoint: "/threads/$threadId/messages");
      return response.isEmpty;
    } catch (e) {
      print("Error checking thread: $e");
      return false;
    }
  }

  @override
  Future<void> createThread() async {
    try {
      if (preferences == null) {
        throw Exception("Preferences not initialized");
      }

      String? reuseThreadId =
          await SharedPreferencesDB(prefs: preferences!).getEmptyThread();
      print('ReusedThread====================>$reuseThreadId');

      if (reuseThreadId != null) {
        if (await isThreadEmpty(reuseThreadId)) {
          threadId = reuseThreadId;
          print('==============ThreadID================>$threadId');
          print("Reusing empty thread=> $threadId");
          return;
        } else {
          await SharedPreferencesDB(prefs: preferences!)
              .removeEmptyThread(reuseThreadId);
        }
      }

      final response =
          await CustomGptApiService().post(endPoint: '/threads', data: {});
      threadId = response.data['id'];
      print("Created new thread=> $threadId");
      await SharedPreferencesDB(prefs: preferences!).saveEmptyThread(threadId!);
    } catch (e) {
      print("Error creating thread: $e");
    }
  }

  @override
  Future<List<ChatMessageModel>> addMessage(String content) async {
    if (threadId == null) {
      print("ThreadId is null, creating new thread");
      await createThread();
      if (threadId == null) {
        throw Exception("Failed to create thread");
      }
    }

    try {
      // Add and return user message immediately
      final userMessage = ChatMessageModel(
        content: content,
        isUser: true,
        senderName: "Mahmoud",
        senderAvatar: 'assets/images/me.jpg',
      );
      messages.add(userMessage);

      // Return immediately with just the user message
      List<ChatMessageModel> currentMessages = List.from(messages);

      // Start processing the API calls without waiting
      _processApiCalls(content);

      return currentMessages;
    } catch (e) {
      print("Error in addMessage: $e");
      if (e is DioException) {
        ServerFailure.fromDioException(e);
      }
      ServerFailure(e.toString());
      return messages;
    }
  }

  // New method to handle API calls separately
  Future<List<ChatMessageModel>> _processApiCalls(String content) async {
    try {
      await SharedPreferencesDB(prefs: preferences!).removeEmptyThread(threadId!);
      
      await CustomGptApiService().post(
        endPoint: '/threads/$threadId/messages',
        data: {"role": "user", "content": content},
      );
      await runAssistant();
      
      // Get and return all messages including bot response
      return await getMessages();
    } catch (e) {
      print("Error in _processApiCalls: $e");
      return messages;
    }
  }

  Future<void> runAssistant() async {
    if (threadId == null) return;
    try {
      await CustomGptApiService().post(
        endPoint: '/threads/$threadId/runs',
        data: {
          "assistant_id": "${Constants.openAIAssistantID}",
          "instructions":
              "Your name is Steve, to the user say hello my name is Steve and I am here to help you then show the response as perfect as possible, because he is a premium user."
        },
      );

      await fetchMessagesWithRetry();
    } catch (e) {
      print("Error running assistant: $e");
    }
  }

  Future<void> fetchMessagesWithRetry(
      {int retries = 8, int delayInSeconds = 3}) async {
    for (int attempt = 1; attempt <= retries; attempt++) {
      final response = await CustomGptApiService()
          .get(endPoint: "/threads/$threadId/messages");
      final List<dynamic> data = response;
      print('Data=>== $data');
      List<dynamic> isNotEmptyContent = [];

      for (var message in data) {
        print('Attempt $attempt to fetch messages...');
        await getMessages();
        if (message['role'] == 'assistant') {
          if (message['content'] != []) {
            print('Content=>====${message['content']}');
            isNotEmptyContent = message['content'];
          }
        }
      }
      if (isNotEmptyContent.isNotEmpty) {
        print('Filld Content=>===== $isNotEmptyContent');
        print('breaked====loop');
        break;
      }
      await Future.delayed(Duration(seconds: delayInSeconds));
    }
    if (threadId != null) {
      bool isEmpty = await isThreadEmpty(threadId!);
      if (isEmpty) {
        await SharedPreferencesDB(prefs: preferences!)
            .saveEmptyThread(threadId!);
      }
    }

    createThread();
    print('Failed to fetch assistant messages after $retries retries.');
  }

  @override
  Future<List<ChatMessageModel>> getMessages() async {
    if (threadId == null) return [];
    try {
      final response = await CustomGptApiService()
          .get(endPoint: "/threads/$threadId/messages");
      final List<dynamic> data = response;
      dynamic message;
      for (message in data) {
        if (message['role'] == 'assistant') {
          for (var content in message['content']) {
            if (content['type'] == 'text' && content['text'] != null) {
              final newMessage = ChatMessageModel(
                content: content['text']['value'],
                isUser: false,
                senderName: "Steve",
                senderAvatar: 'assets/images/steve.jpg',
              );

              if (!messages
                  .any((m) => m.content == newMessage.content && !m.isUser)) {
                messages.add(newMessage);
                content = message;
              }
            }
          }
        }
      }
    } catch (e) {
      if (e is DioException) {
        print(ServerFailure.fromDioException(e));
      }
      print(ServerFailure(e.toString()));
    }
    return messages;
  }
}
