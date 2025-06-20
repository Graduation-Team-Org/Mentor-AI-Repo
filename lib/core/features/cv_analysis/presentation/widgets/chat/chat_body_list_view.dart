import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:popover/popover.dart';
import 'package:road_map_mentor/core/features/cv_analysis/buiseness_logic/all_messages_cubit/cubit/add_messages_cubit.dart';
import 'package:road_map_mentor/core/features/cv_analysis/database/hive/get_all_preferred_mesages_cubit/get_all_preferred_messages_cubit.dart';
import 'package:road_map_mentor/core/features/cv_analysis/database/hive/preferred_messages_cubit/preferred_messages_cubit.dart';
import 'package:road_map_mentor/core/features/cv_analysis/functions/fun.dart';
import 'package:road_map_mentor/core/features/cv_analysis/presentation/widgets/chat/road_map_app_bar.dart';
import 'package:road_map_mentor/core/features/cv_analysis/presentation/widgets/chat/steve_say_hi.dart';
import 'package:road_map_mentor/core/features/reaom_map/data/models/chat_messages_model.dart';
import 'package:road_map_mentor/core/features/reaom_map/presentation/widgets/popover_list_items.dart';
import 'package:road_map_mentor/core/features/reaom_map/presentation/widgets/respnse_widget.dart';
import 'package:road_map_mentor/core/features/reaom_map/presentation/widgets/typing_animation.dart';
import 'package:road_map_mentor/core/utils/colors.dart';

import 'sender_avatar.dart';

class AnalyzeResumeChatBodyListView extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final ScrollController scrollController;

  const AnalyzeResumeChatBodyListView({
    super.key,
    required this.scaffoldKey,
    required this.scrollController,
  });

  @override
  State<AnalyzeResumeChatBodyListView> createState() => _AnalyzeResumeChatBodyListViewState();
}

class _AnalyzeResumeChatBodyListViewState extends State<AnalyzeResumeChatBodyListView> {
  @override
  void initState() {
    super.initState();
    AnalyzeResumeFun().initializePrefs(context: context);
  }

  @override
  void dispose() {
    widget.scrollController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    // Try to get the PreferredMessagesCubit safely
    AnalyzeResumePreferredMessagesCubit? preferredMessagesCubit;
    GetAllAnalyzeResumePreferredMessagesCubit? getAllPreferredMessagesCubit;

    try {
      preferredMessagesCubit = context.read<AnalyzeResumePreferredMessagesCubit>();
      getAllPreferredMessagesCubit =
          context.read<GetAllAnalyzeResumePreferredMessagesCubit>();
    } catch (e) {
      print('Cubit not available in this context: $e');
    }

    return BlocConsumer<AnalyzeReumeAllMessagesCubit, AnalyzeResumeAllMessagesState>(
      listener: (context, state) {
        // Remove the auto-adding of messages here
        // We'll only add messages when the user clicks the like button
      },
      builder: (context, state) {
        final List<ChatMessageModel> messages =
            state is AnalyzeResumeAllMessagesScussess ? state.chatMessagesModel : [];

        return ListView(
          controller: widget.scrollController,
          children: [
            AnalyzeResumeAppBar(scaffoldKey: widget.scaffoldKey),
            const MarcusDayHi(),
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
                                // In the message mapping section, update the popover:
                                Positioned(
                                  top: -5,
                                  right: -5,
                                  child: Builder(
                                    builder: (builderContext) => IconButton(
                                      onPressed: () {
                                        showPopover(
                                          context: builderContext,
                                          bodyBuilder: (popoverContext) {
                                            if (preferredMessagesCubit !=
                                                    null &&
                                                getAllPreferredMessagesCubit !=
                                                    null) {
                                              return MultiBlocProvider(
                                                providers: [
                                                  BlocProvider.value(
                                                      value:
                                                          preferredMessagesCubit),
                                                  BlocProvider.value(
                                                      value:
                                                          getAllPreferredMessagesCubit),
                                                ],
                                                child: ListItems(
                                                  messageContent:
                                                      message.content,
                                                  senderAvatar:
                                                      message.senderAvatar,
                                                ),
                                              );
                                            } else {
                                              return ListItems(
                                                messageContent: message.content,
                                                senderAvatar:
                                                    message.senderAvatar,
                                              );
                                            }
                                          },
                                          onPop: () =>
                                              print('Popover was popped!'),
                                          direction: PopoverDirection.bottom,
                                          width: 80,
                                          height: 200,
                                          arrowHeight: 15,
                                          arrowWidth: 30,
                                          backgroundColor: Colors.white
                                              .withValues(alpha: 0.1),
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
