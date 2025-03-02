import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:road_map_mentor/core/features/reaom_map/buiseness_logic/all_messages_cubit/cubit/add_messages_cubit.dart';
import 'package:road_map_mentor/core/features/reaom_map/data/models/chat_messages_model.dart';
import 'package:road_map_mentor/core/features/reaom_map/data/repos/road_map_repos_imp.dart';
import 'package:road_map_mentor/core/features/reaom_map/presentation/widgets/animated_text_widget.dart';
import 'package:road_map_mentor/core/features/reaom_map/presentation/widgets/respnse_widget.dart';
import 'package:road_map_mentor/core/features/reaom_map/presentation/widgets/typing_animation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatBodyListView extends StatefulWidget {
  const ChatBodyListView({
    super.key,
    required this.scrollController,
  });

  final ScrollController scrollController;

  @override
  State<ChatBodyListView> createState() => _ChatBodyListViewState();
}

class _ChatBodyListViewState extends State<ChatBodyListView> {
  @override
  void initState() {
    super.initState();
    _initializePrefs();
  }

  Future<void> _initializePrefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // Get the existing RoadMapReposImp instance from the cubit
    final reposImpl =
        // ignore: use_build_context_synchronously
        context.read<AllMessagesCubit>().roadMapRepos as RoadMapReposImp;
    reposImpl.preferences = prefs; // Set the preferences
    await reposImpl.createThread(); // Create thread using the same instance
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AllMessagesCubit, AllMessagesState>(
      builder: (context, state) {
        final List<ChatMessageModel> messages =
            state is AllMessagesScussess ? state.chatMessagesModel : [];

        return ListView(
          controller: widget.scrollController,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.asset(
                  'assets/images/steve.jpg',
                  width: 120,
                  height: 120,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: AnimatedTextWidget(
                  response:
                      'Hello, my name is Steve, your road map mentor & i am here to guide you throw your road map learning journey. So what is the road map you want me guide you with ?\nFeel free to ask about any thing 😃',
                ),
              ),
            ),
            // Show all messages
            ...messages.map(
              (message) => Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 5,
                              vertical: 5,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Image.asset(
                                message.senderAvatar,
                                width: 30,
                                height: 30,
                              ),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            message.senderName,
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ResponseWidget(
                          responseText: message.content,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Show typing animation only after the last message if it's from user
            if (messages.isNotEmpty && messages.last.isUser)
              Padding(
                padding: EdgeInsets.only(
                  right: MediaQuery.of(context).size.width * .8,
                  top: MediaQuery.of(context).size.width * .01,
                ),
                child: const TypingAnimation(),
              ),

            const SizedBox(height: 20),
          ],
        );
      },
    );
  }
}

//Get messages provider
