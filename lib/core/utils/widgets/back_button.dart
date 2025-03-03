import 'package:flutter/material.dart';
import 'package:road_map_mentor/core/utils/colors.dart';

class MyBackButton extends StatelessWidget {
  const MyBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.arrow_back,
        size: 30,
        color: AppColors.white,
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }
}
