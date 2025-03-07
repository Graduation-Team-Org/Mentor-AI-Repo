import 'package:flutter/material.dart';
import 'package:road_map_mentor/core/features/reaom_map/presentation/widgets/chat_body_list_view.dart';
import 'package:road_map_mentor/core/features/reaom_map/presentation/widgets/prompt_text_field.dart';
import 'package:road_map_mentor/core/features/reaom_map/presentation/widgets/send_prompt_button.dart';
import 'package:road_map_mentor/core/utils/widgets/app_theme_view.dart';

class ChatScreen extends StatefulWidget {
  final String? threadId;
  const ChatScreen({
    super.key,
    this.threadId,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomInset: true,
      endDrawer: const Drawer(
        // child: YourDrawerContent(),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  const AppViewColor(),
                  ChatBodyListView(
                    scrollController: _scrollController,
                    scaffoldKey: scaffoldKey,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  PromptTextField(
                    controller: _controller,
                  ),
                  //add messages cubit
                  SendPromptButtom(
                    controller: _controller,
                    scrollController: _scrollController,
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
