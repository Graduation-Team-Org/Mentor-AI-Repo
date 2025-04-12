import 'package:flutter/material.dart';

Widget buildPasswordField(String hint, TextEditingController controller, bool isObscure, VoidCallback toggleVisibility) {
    return TextField(
      controller: controller,
      obscureText: isObscure,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white54),
        prefixIcon: const Icon(Icons.lock, color: Colors.white),
        suffixIcon: IconButton(
          icon: Icon(isObscure ? Icons.visibility : Icons.visibility_off, color: Colors.white),
          onPressed: toggleVisibility,
        ),
        filled: true,
        fillColor: const Color(0xFF3E2C5B),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
