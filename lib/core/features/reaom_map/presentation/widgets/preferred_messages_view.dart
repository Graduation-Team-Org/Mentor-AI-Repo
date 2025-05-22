import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:popover/popover.dart';
import 'package:road_map_mentor/core/features/reaom_map/database/hive/get_all_preferred_mesages_cubit/get_all_preferred_messages_cubit.dart';
import 'package:road_map_mentor/core/features/reaom_map/database/hive/models/preferred_messages_model.dart';
import 'package:road_map_mentor/core/features/reaom_map/database/hive/preferred_messages_cubit/preferred_messages_cubit.dart';
import 'package:road_map_mentor/core/features/reaom_map/presentation/widgets/chat_body_list_view.dart';
import 'package:road_map_mentor/core/features/reaom_map/presentation/widgets/popover_list_items.dart';
import 'package:road_map_mentor/core/features/reaom_map/presentation/widgets/respnse_widget.dart';

import 'package:road_map_mentor/core/utils/colors.dart';
import 'package:road_map_mentor/core/utils/widgets/text.dart';

class PreffredMessagesView extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final ScrollController scrollController;

  const PreffredMessagesView({
    super.key,
    required this.scaffoldKey,
    required this.scrollController,
  });

  @override
  State<PreffredMessagesView> createState() => _PreffredMessagesViewState();
}

class _PreffredMessagesViewState extends State<PreffredMessagesView> {
  @override
  void initState() {
    BlocProvider.of<GetAllPreferredMessagesCubit>(context).fetchAllMessages();
    super.initState();
  }

  @override
  void dispose() {
    widget.scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<PreferredMessagesModel> messages =
        BlocProvider.of<GetAllPreferredMessagesCubit>(context)
            .preferredMessages!;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BlocBuilder<PreferredMessagesCubit, PreferredMessagesState>(
        builder: (context, state) {
          return ListView(
            controller: widget.scrollController,
            children: [
              // Show all messages
              ...messages.map(
                (message) => Stack(
                  children: [
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SenderAvatar(senderAvatar: message.msgImage),
                            Spacer(),
                            Text(
                              message.likeDate,
                              style: body,
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 50, top: 5),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppColors.perple,
                                width: 1.1,
                              ),
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(16),
                                bottomRight: Radius.circular(16),
                                topRight: Radius.circular(16),
                              ),
                            ),
                            child: Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 30, bottom: 5, left: 12, right: 30),
                                  child: ResponseWidget(
                                    responseText: message.msgContent,
                                    widgetDuration: 0,
                                  ),
                                ),
                                Positioned(
                                  top: -5,
                                  right: -5,
                                  child: Builder(
                                    builder: (context) => IconButton(
                                      onPressed: () {
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
                    insideSmallCircle(),
                    inBetweenSmallCircle(),
                    outsideSmallCircle(),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          );
        },
      ),
    );
  }
}

Positioned insideSmallCircle() {
  return Positioned(
    top: 38,
    left: 44,
    child: Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.transparet,
        border: Border.all(
          color: AppColors.perple,
          width: 1.5,
        ),
      ),
    ),
  );
}

Positioned outsideSmallCircle() {
  return Positioned(
    top: 32,
    left: 32,
    child: Container(
      width: 5,
      height: 5,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.transparet,
        border: Border.all(
          color: AppColors.perple,
          width: 1.5,
        ),
      ),
    ),
  );
}

Positioned inBetweenSmallCircle() {
  return Positioned(
    top: 35,
    left: 38,
    child: Container(
      width: 6,
      height: 6,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.transparet,
        border: Border.all(
          color: AppColors.perple,
          width: 1.5,
        ),
      ),
    ),
  );
}

