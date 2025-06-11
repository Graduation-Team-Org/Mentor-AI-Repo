import 'package:flutter/material.dart';
import 'package:road_map_mentor/core/features/reaom_map/data/models/chat_messages_model.dart';
import 'package:road_map_mentor/core/features/reaom_map/presentation/widgets/chat/sender_avatar.dart';
import 'package:road_map_mentor/core/features/reaom_map/presentation/widgets/respnse_widget.dart';
import 'package:road_map_mentor/core/features/reaom_map/presentation/widgets/chat/steve_say_hi.dart';
import 'package:road_map_mentor/core/features/reaom_map/presentation/widgets/typing_animation.dart';
import 'package:road_map_mentor/core/utils/colors.dart';

class ChatSessionListView extends StatelessWidget {
  const ChatSessionListView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final List<ChatMessageModel> messages = [];

    return ListView(
      children: [
        const SteveSayHi(),
        // Show all messages
        ...messages.map(
          (message) => Column(
            children: [
              Row(
                mainAxisAlignment: message.isUser
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.start,
                children: [
                  SenderAvatar(senderAvatar: message.senderAvatar),
                ],
              ),
              Padding(
                padding: message.isUser
                    ? const EdgeInsets.only(
                        left: 50,
                        right: 30,
                      ) // User messages padding from left
                    : const EdgeInsets.only(
                        right: 50,
                        left: 40,
                      ), // Bot messages padding from right
                child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color:
                            message.isUser ? AppColors.white : AppColors.perple,
                        width: 1.1,
                      ),
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
                            widgetDuration: 20,
                          ),
                        ),
                      ],
                    )),
              ),
            ],
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
  }
}

class SecondRoute extends StatelessWidget {
  const SecondRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Second Route'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Go back!'),
        ),
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

//Get messages provider
