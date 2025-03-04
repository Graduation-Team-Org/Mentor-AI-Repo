import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:road_map_mentor/core/features/reaom_map/buiseness_logic/all_messages_cubit/cubit/add_messages_cubit.dart';
import 'package:road_map_mentor/core/features/reaom_map/data/models/chat_messages_model.dart';
import 'package:road_map_mentor/core/features/reaom_map/data/repos/road_map_repos_imp.dart';
import 'package:road_map_mentor/core/features/reaom_map/presentation/widgets/respnse_widget.dart';
import 'package:road_map_mentor/core/features/reaom_map/presentation/widgets/steve_say_hi.dart';
import 'package:road_map_mentor/core/features/reaom_map/presentation/widgets/typing_animation.dart';
import 'package:road_map_mentor/core/utils/widgets/back_button.dart';
import 'package:road_map_mentor/core/utils/widgets/text.dart';
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
            RoadMapAppBar(),
            const SteveSayHi(),
            // Show all messages
            ...messages.map(
              (message) => Padding(
                padding: message.isUser
                    ? const EdgeInsets.only(
                        left: 70,
                        top: 40,
                        right: 20,
                      ) // User messages padding from left
                    : const EdgeInsets.only(
                        right: 70,
                        top: 20,
                        left: 20,
                      ), // Bot messages padding from right
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: message.isUser
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: [
                        SenderAvatar(message: message),
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: message.isUser
                            ? Colors.white.withValues(alpha: 0.1)
                            : Colors.white.withValues(alpha: 0.2),
                        borderRadius: message.isUser
                            ? const BorderRadius.only(
                                bottomLeft: Radius.circular(16),
                                bottomRight: Radius.circular(16),
                                topLeft: Radius.circular(16),
                              )
                            : const BorderRadius.only(
                                bottomLeft: Radius.circular(16),
                                bottomRight: Radius.circular(16),
                                topRight: Radius.circular(16),
                              ),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ResponseWidget(
                              responseText: message.content,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
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

class RoadMapAppBar extends StatelessWidget {
  const RoadMapAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 5,
        vertical: MediaQuery.of(context).size.height * 0.02,
      ),
      child: Row(
        children: [
          const MyBackButton(),
          Text(
            'Roadmap',
            style: title1Bold,
          ),
        ],
      ),
    );
  }
}

class SenderName extends StatelessWidget {
  const SenderName({
    super.key,
    required this.message,
  });
  final ChatMessageModel message;
  @override
  Widget build(BuildContext context) {
    return Text(
      message.senderName,
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class SenderAvatar extends StatelessWidget {
  const SenderAvatar({
    super.key,
    required this.message,
  });

  final ChatMessageModel message;
  @override
  Widget build(BuildContext context) {
    return Padding(
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
    );
  }
}

//Get messages provider
