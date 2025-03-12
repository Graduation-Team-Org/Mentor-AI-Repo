import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:popover/popover.dart';
import 'package:road_map_mentor/core/features/reaom_map/buiseness_logic/all_messages_cubit/cubit/add_messages_cubit.dart';
import 'package:road_map_mentor/core/features/reaom_map/data/models/chat_messages_model.dart';
import 'package:road_map_mentor/core/features/reaom_map/functions/fun.dart';
import 'package:road_map_mentor/core/features/reaom_map/presentation/widgets/Road_map_app_bar.dart';
import 'package:road_map_mentor/core/features/reaom_map/presentation/widgets/respnse_widget.dart';
import 'package:road_map_mentor/core/features/reaom_map/presentation/widgets/steve_say_hi.dart';
import 'package:road_map_mentor/core/features/reaom_map/presentation/widgets/typing_animation.dart';
import 'package:road_map_mentor/core/utils/colors.dart';
import 'package:road_map_mentor/core/utils/widgets/text.dart';

class ChatBodyListView extends StatefulWidget {
  final ScrollController scrollController;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const ChatBodyListView({
    super.key,
    required this.scrollController,
    required this.scaffoldKey,
  });

  @override
  State<ChatBodyListView> createState() => _ChatBodyListViewState();
}

class _ChatBodyListViewState extends State<ChatBodyListView> {
  @override
  void initState() {
    super.initState();
    Fun().initializePrefs(context: context);
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
            RoadMapAppBar(scaffoldKey: widget.scaffoldKey),
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
                      SenderAvatar(message: message),
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
                          color: message.isUser ? AppColors.white: AppColors.perple,
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
                      child: message.isUser
                          ? Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ResponseWidget(
                                    responseText: message.content,
                                    widgetDuration: 20,
                                  ),
                                ),
                              ],
                            )
                          : Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 30, bottom: 5, left: 12, right: 30),
                                  child: ResponseWidget(
                                    responseText: message.content,
                                    widgetDuration: 20,
                                  ),
                                ),
                                Positioned(
                                  top: -5,
                                  right: -5,
                                  child: Builder(
                                    builder: (context) => IconButton(
                                      onPressed: () {
                                        // final RenderBox button = context
                                        //     .findRenderObject() as RenderBox;
                                        // final Offset position =
                                        //     button.localToGlobal(Offset.zero);

                                        showPopover(
                                          context: context,
                                          bodyBuilder: (context) =>
                                              const ListItems(),
                                          onPop: () =>
                                              print('Popover was popped!'),
                                          direction: PopoverDirection.bottom,
                                          width: 80,
                                          height: 200,
                                          arrowHeight: 15,
                                          arrowWidth: 30,
                                          backgroundColor:
                                              Colors.white.withOpacity(0.1),
                                          barrierColor: Colors.black54,
                                          transitionDuration:
                                              const Duration(milliseconds: 150),
                                          constraints: BoxConstraints(
                                            maxWidth: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.8,
                                            maxHeight: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.5,
                                          ),
                                        );
                                      },
                                      icon: SvgPicture.asset(
                                        'assets/images/Menu_Dots_2.svg',
                                        width: 20,
                                        height: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ),
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
      },
    );
  }
}

class ListItems extends StatelessWidget {
  const ListItems({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.darkPerple.withValues(alpha: 0.7), // Dark background
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: ListView(
          padding: const EdgeInsets.all(2),
          children: [
            IconButton(
              onPressed: () {},
              icon: Row(
                children: [
                  const Icon(
                    Icons.copy,
                    color: Colors.white,
                    size: 12,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    'Copy',
                    style: body.copyWith(fontSize: 12),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Row(
                children: [
                  SvgPicture.asset(
                    'assets/images/Heart_Angle.svg',
                    width: 15,
                    height: 15,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    'Like',
                    style: body.copyWith(fontSize: 12),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Row(
                children: [
                  SvgPicture.asset(
                    'assets/images/Share.svg',
                    width: 15,
                    height: 15,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    'Share',
                    style: body.copyWith(fontSize: 12),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Row(
                children: [
                  SvgPicture.asset(
                    'assets/images/Trash_Bin_Minimalistic.svg',
                    width: 15,
                    height: 15,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    'Delete',
                    style: body.copyWith(fontSize: 12),
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
