import 'package:flutter/material.dart';
import 'package:road_map_mentor/core/features/reaom_map/data/models/chat_messages_model.dart';
import 'package:road_map_mentor/core/features/reaom_map/presentation/widgets/chat/sender_avatar.dart';
import 'package:road_map_mentor/core/features/reaom_map/presentation/widgets/respnse_widget.dart';
import 'package:road_map_mentor/core/utils/colors.dart';
import 'package:road_map_mentor/core/utils/widgets/app_theme_view.dart';
import 'dart:ui';

class SharedChatViewScreen extends StatelessWidget {
  final String conversationId;
  final List<ChatMessageModel> messages;

  const SharedChatViewScreen({
    super.key,
    required this.conversationId,
    required this.messages,
  });

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shared Conversation'),
        backgroundColor: AppColors.darkPerple,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  const AppViewColor(),
                  // Background elements
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: ImageFiltered(
                      imageFilter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                      child: Image.asset('assets/images/Ellipse_1.png'),
                    ),
                  ),
                  // More background elements as needed
                  
                  // Chat messages
                  ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(16.0),
                    children: [
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            'This is a shared Road Map Mentor conversation',
                            style: TextStyle(
                              color: Colors.white70,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ),
                      
                      // Display all messages
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
                                    )
                                  : const EdgeInsets.only(
                                      right: 50,
                                      left: 40,
                                    ),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: message.isUser
                                        ? AppColors.white
                                        : AppColors.perple,
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
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: ResponseWidget(
                                    responseText: message.content,
                                    widgetDuration: 0, // No animation in shared view
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}