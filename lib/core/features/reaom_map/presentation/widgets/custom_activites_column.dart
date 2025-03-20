import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomRowIconText(
          icon: SvgPicture.asset(
            'assets/images/fi_share.svg',
            width: 20,
            height: 20,
          ),
          onIconPressed: () {},
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
