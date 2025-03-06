import 'package:flutter/material.dart';
import 'package:road_map_mentor/core/features/reaom_map/presentation/widgets/inside_printer.dart';
import 'package:road_map_mentor/core/utils/colors.dart';
import 'package:road_map_mentor/core/utils/widgets/back_button.dart';
import 'package:road_map_mentor/core/utils/widgets/text.dart';

class RoadMapAppBar extends StatelessWidget {
  const RoadMapAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 5,
        vertical: MediaQuery.of(context).size.height * 0.02,
      ),
      child: Row(
        children: [
          const MyBackButton(),
          Padding(
            padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.23),
            child: Text(
              'Roadmap',
              style: title1Bold,
            ),
          ),
          // const Spacer(),
          Padding(
            padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.12),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Image.asset('assets/images/PenNewSquare.png'),
                ),
                Container(
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
              ],
            ),
          )
        ],
      ),
    );
  }
}

