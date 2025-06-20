import 'package:flutter/material.dart';
import 'package:road_map_mentor/core/features/reaom_map/data/models/chat_messages_model.dart';
import 'package:road_map_mentor/core/features/reaom_map/presentation/widgets/chat/sender_avatar.dart';
import 'package:road_map_mentor/core/features/reaom_map/presentation/widgets/respnse_widget.dart';
import 'package:road_map_mentor/core/features/reaom_map/presentation/widgets/chat/steve_say_hi.dart';
import 'package:road_map_mentor/core/utils/colors.dart';

class ChatSessionListView extends StatelessWidget {
  final List<ChatMessageModel> messages;

  const ChatSessionListView({
    super.key,
    this.messages = const [],
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        if (messages.isEmpty) const SteveSayHi(),
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
                    ),
                    borderRadius: BorderRadius.circular(10),
                    color: message.isUser
                        ? AppColors.white.withOpacity(0.1)
                        : AppColors.perple.withOpacity(0.1),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ResponseWidget(
                      responseText: message.content,
                      widgetDuration: 20,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
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
