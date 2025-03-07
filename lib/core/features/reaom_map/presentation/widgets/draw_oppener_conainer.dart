import 'package:flutter/material.dart';
import 'package:road_map_mentor/core/features/reaom_map/presentation/widgets/inside_printer.dart';
import 'package:road_map_mentor/core/utils/colors.dart';

class DrawOppenerContainer extends StatelessWidget {
  const DrawOppenerContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {},
      icon: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          color: AppColors.transparet,
          border: Border.all(
            color: AppColors.white,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        child: CustomPaint(
          painter: InsideVectorPainter(),
        ),
      ),
    );
  }
}