
import 'package:flutter/material.dart';
import 'package:road_map_mentor/core/utils/widgets/text.dart';

class CustomDrawerHeader extends StatelessWidget {
  const CustomDrawerHeader({
    super.key,
    required TextEditingController chatSearchcontroller,
    required this.scaffoldKey,
  });

  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.asset(
            'assets/images/steve.png',
            width: 35,
            height: 35,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          'Steve',
          style: title2Bold,
        ),
      ],
    );
  }
}
