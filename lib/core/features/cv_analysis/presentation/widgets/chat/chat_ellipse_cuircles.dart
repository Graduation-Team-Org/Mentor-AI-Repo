import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:road_map_mentor/core/features/reaom_map/presentation/widgets/drawer/custom_ellipse_cuircles.dart';

class ChatEllipseCuircles extends StatelessWidget {
  const ChatEllipseCuircles({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomEllipseCircule(
          alignment: const AlignmentDirectional(1.1, 1.1),
          imgPath: 'assets/images/Ellipse_1.svg',
          imageFilter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        ),
        CustomEllipseCircule(
          alignment: const AlignmentDirectional(-1.4, 0.8),
          imgPath: 'assets/images/Ellipse_2.svg',
          imageFilter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        ),
        CustomEllipseCircule(
          alignment: const AlignmentDirectional(-1.4, 1),
          imgPath: 'assets/images/Ellipse_3.svg',
          imageFilter: ImageFilter.blur(sigmaX: 220, sigmaY: 220),
        ),
        CustomEllipseCircule(
          alignment: const AlignmentDirectional(-1.5, 1.1),
          imgPath: 'assets/images/Ellipse_4.svg',
          imageFilter: ImageFilter.blur(sigmaX: 300, sigmaY: 300),
        ),
      ],
    );
  }
}
