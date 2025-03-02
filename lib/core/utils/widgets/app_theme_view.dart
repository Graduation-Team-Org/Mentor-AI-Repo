import 'package:flutter/material.dart';
import 'package:road_map_mentor/core/utils/widgets/custom_filter.dart';

class NotesViewColor extends StatelessWidget {
  const NotesViewColor({super.key});

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
              color: Color(0xff110A2B),
            ),
          ),
        ),
        Align(
          alignment: const AlignmentDirectional(3, -0.6),
          child: Container(
            height: 500,
            width: 300,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 11, 6, 28),
            ),
          ),
        ),
        Align(
          alignment: const AlignmentDirectional(-3, -0.6),
          child: Container(
            height: 500,
            width: 300,
            decoration: const BoxDecoration(
              color:Color.fromARGB(255, 11, 6, 28),
            ),
          ),
        ),
        Align(
          alignment: const AlignmentDirectional(0, -1.2),
          child: Container(
            height: 300,
            width: 300,
            decoration: const BoxDecoration(
              color:Color.fromARGB(255, 11, 6, 28),
            ),
          ),
        ),
        const CustomFilter(),
      ],
    );
  }
}
