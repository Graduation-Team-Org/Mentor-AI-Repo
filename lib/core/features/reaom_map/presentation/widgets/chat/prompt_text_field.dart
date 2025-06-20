import 'package:flutter/material.dart';
import 'package:road_map_mentor/core/utils/colors.dart';
import 'package:road_map_mentor/core/utils/widgets/text.dart';

class PromptTextField extends StatelessWidget {
  const PromptTextField({super.key, required this.controller});
  final TextEditingController controller;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextField(
        controller: controller,
        style: bodyBold,
        decoration: InputDecoration(
          hintText: "Ask waht's on mind...",
          filled: true,
          fillColor: const Color.fromARGB(217, 30, 17, 50).withValues(alpha: 0.1),
          hintStyle: TextStyle(
            color: AppColors.white.withValues(alpha: 0.8),
          ),
          
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}