import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:road_map_mentor/core/features/reaom_map/presentation/enum/drawer_content.dart';
import 'package:road_map_mentor/core/features/reaom_map/presentation/widgets/custom_icon_text.dart';
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
      children: [
        CustomRowIconText(
          icon: const Icon(
            Icons.share_outlined,
            color: AppColors.white,
          ),
          onIconPressed: () {},
          endTxt: 'Share Chat',
        ),
        CustomRowIconText(
          icon: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: currentContent == DrawerContent.history 
                    ? AppColors.perple 
                    : AppColors.white,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Icon(
              Icons.notes_rounded,
              color: currentContent == DrawerContent.history 
                  ? AppColors.perple 
                  : AppColors.white,
              size: 20,
            ),
          ),
          onIconPressed: onHistoryPressed,
          endTxt: 'History',
        ),
        CustomRowIconText(
          icon: Icon(
            FontAwesomeIcons.heart,
            color: currentContent == DrawerContent.preferred 
                ? AppColors.perple 
                : AppColors.white,
          ),
          onIconPressed: onPreferredPressed,
          endTxt: 'Preferred message',
        ),
      ],
    );
  }
}
