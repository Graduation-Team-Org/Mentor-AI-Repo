import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:road_map_mentor/core/features/reaom_map/presentation/widgets/custom_icon_text.dart';
import 'package:road_map_mentor/core/utils/colors.dart';

class CustomChatActivitiesColumn extends StatelessWidget {
  const CustomChatActivitiesColumn({super.key});

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
                  color: AppColors.white,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(5)),
            child: const Icon(
              Icons.notes_rounded,
              color: AppColors.white,
              size: 20,
            ),
          ),
          onIconPressed: () {},
          endTxt: 'History',
        ),
        CustomRowIconText(
          icon: const Icon(
            FontAwesomeIcons.heart,
            color: AppColors.white,
          ),
          onIconPressed: () {},
          endTxt: 'Preferred message',
        ),
      ],
    );
  }
}
