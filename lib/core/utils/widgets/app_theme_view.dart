import 'package:flutter/material.dart';
import 'package:road_map_mentor/core/utils/widgets/custom_filter.dart';

class AppViewColor extends StatelessWidget {
  const AppViewColor({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: const AlignmentDirectional(0, 1),
          child: Container(
            height: 600,
            width: 300,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 48, 10, 75),
            ),
          ),
        ),
        Align(
          alignment: const AlignmentDirectional(3, -0.6),
          child: Container(
            height: 500,
            width: 300,
            decoration: const BoxDecoration(
              color:Color.fromARGB(255, 46, 25, 75),
            ),
          ),
        ),
        Align(
          alignment: const AlignmentDirectional(-3, -0.6),
          child: Container(
            height: 500,
            width: 300,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 48, 25, 75),
            ),
          ),
        ),
        Align(
          alignment: const AlignmentDirectional(0, -1.2),
          child: Container(
            height: 300,
            width: 300,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 46, 21, 80),
            ),
          ),
        ),
        const CustomFilter(),
      ],
    );
  }
}
