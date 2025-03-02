import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:road_map_mentor/core/features/reaom_map/buiseness_logic/all_messages_cubit/cubit/add_messages_cubit.dart';
import 'package:road_map_mentor/core/features/reaom_map/functions/fun.dart';

class SendPromptButtom extends StatelessWidget {
  const SendPromptButtom({
    super.key,
    required this.controller,
    required this.scrollController,
  });
  final TextEditingController controller;
  final ScrollController scrollController;
  @override
  Widget build(BuildContext context) {
    return Padding(
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
            if (controller.text.trim().isNotEmpty) {
              BlocProvider.of<AllMessagesCubit>(context)
                  .addmessage(content: controller.text);
              controller.clear();
              Fun().scrollToBottom(
                scrollController: scrollController,
              );
            }
          },
        ),
      ),
    );
  }
}