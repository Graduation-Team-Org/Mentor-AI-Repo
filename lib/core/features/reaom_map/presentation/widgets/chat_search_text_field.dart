import 'package:flutter/material.dart';

class ChatSearchTextField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback? onTap;

  const ChatSearchTextField({
    super.key,
    required this.controller,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      onTap: onTap,
      decoration: InputDecoration(
        isDense: true, // Makes the TextField more compact
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        hintText: 'Search ...',
        hintStyle: const TextStyle(
          color: Colors.white54,
          fontSize: 14,
        ),
        fillColor: Colors.white.withValues(alpha: 0.1),
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        prefixIcon: const Icon(
          Icons.search,
          color: Colors.white54,
          size: 20,
        ),
      ),
    );
  }
}
