import 'package:flutter/material.dart';

Widget buildTextField(IconData icon, String hint, TextEditingController controller, FormFieldValidator<String> validator) {
    return TextFormField(
      controller: controller,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.white54),
        prefixIcon: Icon(icon, color: Colors.white),
        filled: true,
        fillColor: Color(0xFF3E2C5B),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
      ),
      validator: validator,
    );
  }
