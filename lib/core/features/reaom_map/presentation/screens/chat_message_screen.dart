import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:road_map_mentor/core/constants/constants.dart';
import 'package:road_map_mentor/core/features/reaom_map/buiseness_logic/add_messages_cubit/cubit/add_messages_cubit.dart';
import 'package:road_map_mentor/core/features/reaom_map/data/models/chat_messages_model.dart';
import 'package:road_map_mentor/core/features/reaom_map/data/repos/road_map_repos.dart';
import 'package:road_map_mentor/core/features/reaom_map/data/repos/road_map_repos_imp.dart';
import 'package:road_map_mentor/core/features/reaom_map/database/preferences/shared_preferences.dart';
import 'package:road_map_mentor/core/features/reaom_map/functions/fun.dart';
import 'package:road_map_mentor/core/features/reaom_map/presentation/widgets/back_ground_gift.dart';
import 'package:road_map_mentor/core/features/reaom_map/presentation/widgets/chat_body_list_view.dart';
import 'package:road_map_mentor/core/features/reaom_map/utils/services/custom_gpt_api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final String? threadId;
  // final String _emptyThreadsKey = 'empty_threads';

  ChatScreen({
    super.key,
    this.threadId,
  });

  // CustomGptApiService()

  // Future<bool> _isThreadEmpty(String threadId) async {
  //   try {
  //     final response = await CustomGptApiService()
  //         .get(endPoint: "/threads/$threadId/messages");
  //     return response.isEmpty;
  //   } catch (e) {
  //     print("Error checking thread: $e");
  //     return false;
  //   }
  // }

  // Future<void> createThread() async {
  //   try {
  //     String? reuseThreadId =
  //         await SharedPreferencesDB(prefs: prefs).getEmptyThread();

  //     if (reuseThreadId != null) {
  //       if (await _isThreadEmpty(reuseThreadId)) {
  //         setState(() {
  //           threadId = reuseThreadId;
  //         });
  //         print("Reusing empty thread=> $threadId");
  //         return;
  //       } else {
  //         await SharedPreferencesDB(prefs: prefs)
  //             .removeEmptyThread(reuseThreadId);
  //       }
  //     }

  //     final response =
  //         await CustomGptApiService().post(endPoint: '/threads', data: {});
  //     setState(() {
  //       threadId = response.data['id'];
  //     });
  //     print("Created new thread=> $threadId");

  //     await SharedPreferencesDB(prefs: prefs).saveEmptyThread(threadId!);
  //   } catch (e) {
  //     print("Error creating thread: $e");
  //   }
  // }

  // Future<void> addMessage(String content) async {
  //   if (threadId == null) return;
  //   try {
  //     setState(() {
  //       messages.add(ChatMessageModel(
  //         content: content,
  //         isUser: true,
  //         senderName: "Mahmoud",
  //         senderAvatar: 'assets/images/me.jpg',
  //       ));
  //     });
  //     Fun().scrollToBottom(scrollController: _scrollController);

  //     await SharedPreferencesDB(prefs: prefs).removeEmptyThread(threadId!);

  //     await CustomGptApiService().post(
  //       endPoint: '/threads/$threadId/messages',
  //       data: {"role": "user", "content": content},
  //     );
  //     // await _dio.post(
  //     //   '/threads/$threadId/messages',
  //     //   data: {"role": "user", "content": content},
  //     // );
  //     runAssistant();
  //   } catch (e) {
  //     print("Error adding message: $e");
  //   }
  // }

  // Future<void> runAssistant() async {
  //   if (threadId == null) return;
  //   try {
  //     await CustomGptApiService().post(
  //       endPoint: '/threads/$threadId/runs',
  //       data: {
  //         "assistant_id": "${Constants.openAIAssistantID}",
  //         "instructions":
  //             "Your name is Steve, to the user say hello my name is Steve and I am here to help you then show the response as perfect as possible, because he is a premium user."
  //       },
  //     );

  //     await fetchMessagesWithRetry();
  //   } catch (e) {
  //     print("Error running assistant: $e");
  //   }
  // }

  // Future<void> fetchMessagesWithRetry(
  //     {int retries = 8, int delayInSeconds = 3}) async {
  //   for (int attempt = 1; attempt <= retries; attempt++) {
  //     final response = await CustomGptApiService()
  //         .get(endPoint: "/threads/$threadId/messages");
  //     final List<dynamic> data = response;
  //     print('Data=>== $data');
  //     List<dynamic> isNotEmptyContent = [];

  //     for (var message in data) {
  //       print('Attempt $attempt to fetch messages...');
  //       await getMessages();
  //       if (message['role'] == 'assistant') {
  //         if (message['content'] != []) {
  //           print('Content=>====${message['content']}');
  //           isNotEmptyContent = message['content'];
  //         }
  //       }
  //     }
  //     if (isNotEmptyContent.isNotEmpty) {
  //       print('Filld Content=>===== $isNotEmptyContent');
  //       print('breaked====loop');
  //       break;
  //     }
  //     await Future.delayed(Duration(seconds: delayInSeconds));
  //   }
  //   if (threadId != null) {
  //     bool isEmpty = await _isThreadEmpty(threadId!);
  //     if (isEmpty) {
  //       await SharedPreferencesDB(prefs: prefs).saveEmptyThread(threadId!);
  //     }
  //   }
  //   setState(() {
  //     createThread();
  //   });
  //   print('Failed to fetch assistant messages after $retries retries.');
  // }

  // Future<void> getMessages() async {
  //   if (threadId == null) return;
  //   try {
  //     final response = await CustomGptApiService()
  //         .get(endPoint: "/threads/$threadId/messages");
  //     final List<dynamic> data = response;
  //     for (var message in data) {
  //       if (message['role'] == 'assistant') {
  //         for (var content in message['content']) {
  //           if (content['type'] == 'text' && content['text'] != null) {
  //             final newMessage = ChatMessageModel(
  //               content: content['text']['value'],
  //               isUser: false,
  //               senderName: "Steve",
  //               senderAvatar: 'assets/images/steve.jpg',
  //             );

  //             if (!messages
  //                 .any((m) => m.content == newMessage.content && !m.isUser)) {
  //               setState(() {
  //                 messages.add(newMessage);
  //                 content = message;
  //               });
  //             }
  //           }
  //         }
  //       }
  //     }
  //   } catch (e) {
  //     print("Error fetching messages: $e");
  //   }
  // }

  // @override
  // void dispose() {
  //   super.dispose();
  //   _controller.dispose();
  //   _scrollController.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    

    return Scaffold(
      appBar: AppBar(title: const Text("Chat With Steve")),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  const BackgroundGif(),
                  ChatBodyListView(
                    scrollController: _scrollController,
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, -2),
                    blurRadius: 4,
                    color: Colors.black.withOpacity(0.1),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          hintText: "Enter your message",
                          filled: true,
                          fillColor: Colors.black.withOpacity(0.9),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                    //add messages cubit
                    IconButton(
                      icon: const Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        if (_controller.text.trim().isNotEmpty) {
                          BlocProvider.of<AllMessagesCubit>(context)
                              .addmessage(content: _controller.text);
                          _controller.clear();
                          Fun().scrollToBottom(
                              scrollController: _scrollController);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
