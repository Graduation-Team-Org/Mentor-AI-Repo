import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:road_map_mentor/core/features/reaom_map/presentation/widgets/inside_printer.dart';
import 'package:road_map_mentor/core/utils/colors.dart';

class DrawOppenerContainer extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const DrawOppenerContainer({
    super.key,
    required this.scaffoldKey,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        scaffoldKey.currentState?.openEndDrawer();  // Open the drawer
      },
      icon: SvgPicture.asset('assets/images/Sidebar_Minimalistic.svg'),
    );
  }
}
