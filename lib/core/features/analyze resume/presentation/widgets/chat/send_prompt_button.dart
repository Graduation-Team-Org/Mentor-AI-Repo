import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
      child: Stack(
        children: [
          SvgPicture.asset('assets/images/Ellipse.svg',width: 50,height: 50,),
          IconButton(
            icon: SvgPicture.asset('assets/images/Plain_2.svg',width: 27,height: 27,),
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                BlocProvider.of<AllMessagesCubit>(context)
                    .addmessage(content: controller.text, context: context);
                controller.clear();
                Fun().scrollToBottom(
                  scrollController: scrollController,
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
