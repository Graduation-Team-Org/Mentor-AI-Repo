import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:road_map_mentor/core/features/reaom_map/buiseness_logic/all_messages_cubit/cubit/add_messages_cubit.dart';
import 'package:road_map_mentor/core/features/reaom_map/functions/fun.dart';
import 'package:road_map_mentor/core/features/reaom_map/presentation/widgets/back_ground_gift.dart';
import 'package:road_map_mentor/core/features/reaom_map/presentation/widgets/chat_body_list_view.dart';
import 'package:road_map_mentor/core/utils/widgets/app_theme_view.dart';

class ChatScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final String? threadId;
  ChatScreen({
    super.key,
    this.threadId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  const AppViewColor(),
                  ChatBodyListView(
                    scrollController: _scrollController,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: "Enter your message",
                        filled: true,
                        fillColor: const Color.fromARGB(217, 30, 17, 50),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),

                  //add messages cubit
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        color: const Color.fromARGB(217, 97, 63, 147),
                      ),
                      child: IconButton(
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
                    ),
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
