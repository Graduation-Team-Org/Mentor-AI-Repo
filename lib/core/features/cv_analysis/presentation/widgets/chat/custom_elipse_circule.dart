import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomEllipseCircule extends StatelessWidget {
  const CustomEllipseCircule({
    super.key,
    required this.alignment,
    required this.imgPath,
    required this.imageFilter,
  });
  final AlignmentGeometry alignment;
  final String imgPath;
  final ImageFilter imageFilter;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: ImageFiltered(
        imageFilter: imageFilter,
        child: SvgPicture.asset(
          imgPath,
        ),
      ),
    );
  }
}
