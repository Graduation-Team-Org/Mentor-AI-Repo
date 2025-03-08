import 'package:flutter/material.dart';
import 'package:road_map_mentor/core/utils/widgets/text.dart';

class CustomRowIconText extends StatelessWidget {
  const CustomRowIconText({
    super.key,
    required this.icon,
    required this.onIconPressed,
    required this.endTxt,
  });

  final Widget icon;
  final void Function() onIconPressed;
  final String endTxt;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: onIconPressed,
          icon: icon,
        ),
        Text(
          endTxt,
          style: body,
        )
      ],
    );
  }
}
