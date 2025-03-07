import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:road_map_mentor/core/utils/colors.dart';

class NewChatContainer extends StatelessWidget {
  const NewChatContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {},
      icon: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.white,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          const Positioned(
            top: -1,
            right: -1,
            child: Icon(
              FontAwesomeIcons.pencil,
              color: AppColors.white,
              size: 17,
            ),
          ),
        ],
      ),
    );
  }
}