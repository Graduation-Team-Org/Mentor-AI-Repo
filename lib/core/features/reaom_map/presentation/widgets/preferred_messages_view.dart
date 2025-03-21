import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:popover/popover.dart';
import 'package:intl/intl.dart';
import 'package:road_map_mentor/core/features/reaom_map/data/models/chat_messages_model.dart';
import 'package:road_map_mentor/core/features/reaom_map/presentation/widgets/chat_body_list_view.dart';
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
    super.initState();
  }

  @override
  void dispose() {
    widget.scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<ChatMessageModel> messages = [
      ChatMessageModel(
        content:
            'This is the preffred messages container which contain all the liked messages',
        isUser: false,
        senderName: 'Steve',
        senderAvatar: 'assets/images/steve.png',
      ),
    ];
    var currentDate = DateTime.now();
    var formattedCurrentDate = DateFormat('dd-mm-yyyy').format(currentDate);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
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
                        SenderAvatar(message: message),
                        Spacer(),
                        Text(
                          formattedCurrentDate,
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
                                responseText: message.content,
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
                                      onPop: () => print('Popover was popped!'),
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
                                        maxWidth:
                                            MediaQuery.of(context).size.width *
                                                0.8,
                                        maxHeight:
                                            MediaQuery.of(context).size.height *
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
