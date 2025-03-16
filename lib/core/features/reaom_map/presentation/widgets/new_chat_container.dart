import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
      icon: SvgPicture.asset('assets/images/Pen_New_Square.svg',fit: BoxFit.contain,),
    );
  }
}