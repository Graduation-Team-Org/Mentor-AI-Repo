import 'package:flutter/material.dart';

class PromptTextField extends StatelessWidget {
  const PromptTextField({super.key, required this.controller});
  final TextEditingController controller;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: "Enter your message",
          filled: true,
          fillColor: const Color.fromARGB(217, 30, 17, 50),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}