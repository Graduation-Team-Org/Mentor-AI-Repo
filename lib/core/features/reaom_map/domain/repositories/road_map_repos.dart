// import 'package:road_map_mentor/core/features/reaom_map/data/models/chat_messages_model.dart';
// import 'package:road_map_mentor/core/constants/constants.dart';
// import 'package:road_map_mentor/core/features/reaom_map/utils/services/custom_gpt_api_service.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:road_map_mentor/core/features/reaom_map/database/preferences/shared_preferences.dart';

// class RoadMapRepos {
//   final CustomGptApiService _apiService = CustomGptApiService();
//   final SharedPreferences prefs;

//   RoadMapRepos({required this.prefs});

//   Future<bool> isThreadEmpty(String threadId) async {
//     try {
//       final response = await _apiService.get(endPoint: "/threads/$threadId/messages");
//       return response.isEmpty;
//     } catch (e) {
//       print("Error checking thread: $e");
//       return false;
//     }
//   }

//   Future<String?> createThread() async {
//     try {
//       String? reuseThreadId = await SharedPreferencesDB(prefs: prefs).getEmptyThread();
      
//       if (reuseThreadId != null) {
//         if (await isThreadEmpty(reuseThreadId)) {
//           print("Reusing empty thread=> $reuseThreadId");
//           return reuseThreadId;
//         } else {
//           await SharedPreferencesDB(prefs: prefs).removeEmptyThread(reuseThreadId);
//         }
//       }

//       final response = await _apiService.post(endPoint: '/threads', data: {});
//       final newThreadId = response.data['id'];
//       print("Created new thread=> $newThreadId");
      
//       await SharedPreferencesDB(prefs: prefs).saveEmptyThread(newThreadId);
//       return newThreadId;
//     } catch (e) {
//       print("Error creating thread: $e");
//       return null;
//     }
//   }

//   Future<bool> addMessage(String threadId, String content) async {
//     try {
//       await SharedPreferencesDB(prefs: prefs).removeEmptyThread(threadId);
//       await _apiService.post(
//         endPoint: '/threads/$threadId/messages',
//         data: {"role": "user", "content": content},
//       );
//       return true;
//     } catch (e) {
//       print("Error adding message: $e");
//       return false;
//     }
//   }

//   Future<bool> runAssistant(String threadId) async {
//     try {
//       await _apiService.post(
//         endPoint: '/threads/$threadId/runs',
//         data: {
//           "assistant_id": "${Constants.openAIAssistantID}",
//           "instructions":
//               "Your name is Steve, to the user say hello my name is Steve and I am here to help you then show the response as perfect as possible, because he is a premium user."
//         },
//       );
//       return true;
//     } catch (e) {
//       print("Error running assistant: $e");
//       return false;
//     }
//   }

//   Future<List<ChatMessageModel>> getMessages(String threadId) async {
//     try {
//       final response = await _apiService.get(endPoint: "/threads/$threadId/messages");
//       final List<dynamic> data = response;
//       List<ChatMessageModel> messages = [];

//       for (var message in data) {
//         if (message['role'] == 'assistant') {
//           for (var content in message['content']) {
//             if (content['type'] == 'text' && content['text'] != null) {
//               messages.add(ChatMessageModel(
//                 content: content['text']['value'],
//                 isUser: false,
//                 senderName: "Steve",
//                 senderAvatar: 'assets/images/steve.jpg',
//               ));
//             }
//           }
//         }
//       }
//       return messages;
//     } catch (e) {
//       print("Error fetching messages: $e");
//       return [];
//     }
//   }

//   Future<List<ChatMessageModel>> fetchMessagesWithRetry(
//       String threadId, {int retries = 8, int delayInSeconds = 3}) async {
//     List<ChatMessageModel> messages = [];
    
//     for (int attempt = 1; attempt <= retries; attempt++) {
//       final response = await _apiService.get(endPoint: "/threads/$threadId/messages");
//       final List<dynamic> data = response;
//       List<dynamic> isNotEmptyContent = [];

//       for (var message in data) {
//         print('Attempt $attempt to fetch messages...');
//         messages = await getMessages(threadId);
//         if (message['role'] == 'assistant') {
//           if (message['content'] != []) {
//             isNotEmptyContent = message['content'];
//           }
//         }
//       }
      
//       if (isNotEmptyContent.isNotEmpty) {
//         print('Successfully received messages');
//         return messages;
//       }
//       await Future.delayed(Duration(seconds: delayInSeconds));
//     }

//     if (await isThreadEmpty(threadId)) {
//       await SharedPreferencesDB(prefs: prefs).saveEmptyThread(threadId);
//     }
    
//     print('Failed to fetch assistant messages after $retries retries.');
//     return messages;
//   }
// } 