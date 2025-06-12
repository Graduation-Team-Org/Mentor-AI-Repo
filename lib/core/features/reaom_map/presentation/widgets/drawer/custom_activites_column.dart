import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:road_map_mentor/core/features/reaom_map/buiseness_logic/all_messages_cubit/cubit/add_messages_cubit.dart';
import 'package:road_map_mentor/core/features/reaom_map/presentation/enum/drawer_content.dart';
import 'package:road_map_mentor/core/features/reaom_map/presentation/widgets/custom_icon_text.dart';
import 'package:road_map_mentor/core/features/reaom_map/utils/services/share_road_map_chat_screen.dart';
import 'package:road_map_mentor/core/utils/colors.dart';

class CustomChatActivitiesColumn extends StatelessWidget {
  final VoidCallback onHistoryPressed;
  final VoidCallback onPreferredPressed;
  final DrawerContent currentContent;

  const CustomChatActivitiesColumn({
    super.key,
    required this.onHistoryPressed,
    required this.onPreferredPressed,
    required this.currentContent,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomRowIconText(
          icon: SvgPicture.asset(
            'assets/images/fi_share.svg',
            width: 20,
            height: 20,
          ),
          onIconPressed: () {
            // Get the current messages from the AllMessagesCubit
            final allMessagesCubit = context.read<AllMessagesCubit>();
            if (allMessagesCubit.state is AllMessagesScussess) {
              final messages = (allMessagesCubit.state as AllMessagesScussess).chatMessagesModel;
              // Share the conversation
              ShareRoadMapChatScreen.shareConversation(context, messages);
            } else {
              // Show a message if there are no messages to share
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('No conversation to share yet')),
              );
            }
          },
          endTxt: 'Share Chat',
        ),
        CustomRowIconText(
          icon: SvgPicture.asset(
            'assets/images/Pen_New_Square.svg',
            height: 20,
            width: 20,
          ),
          onIconPressed: () {},
          endTxt: 'New Chat',
        ),
        CustomRowIconText(
          icon: currentContent == DrawerContent.history
              ? SvgPicture.asset(
                  'assets/images/Document_Text.svg',
                  color: AppColors.perple,
                )
              : SvgPicture.asset('assets/images/Document_Text.svg'),
          onIconPressed: onHistoryPressed,
          endTxt: 'History',
        ),
        CustomRowIconText(
          icon: currentContent == DrawerContent.preferred
              ? SvgPicture.asset('assets/images/Solid_heart.svg')
              : SvgPicture.asset(
                  'assets/images/Heart_Angle.svg',
                ),
          onIconPressed: onPreferredPressed,
          endTxt: 'Preferred message',
        ),
      ],
    );
  }
}
