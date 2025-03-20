import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MyBackButton extends StatelessWidget {
  const MyBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: SvgPicture.asset('assets/images/fi_arrow-left.svg'),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }
}
