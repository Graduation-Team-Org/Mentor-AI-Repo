import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:road_map_mentor/core/utils/colors.dart';

class CustomFilter extends StatelessWidget {
  const CustomFilter({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.transparet,
        ),
      ),
    );
  }
}
