// import 'package:flutter/material.dart';

// Widget _buildPasswordField(String hint, TextEditingController controller) {
//     return TextFormField(
//       controller: controller,
//       obscureText: !_isPasswordVisible,
//       style: TextStyle(color: Colors.white),
//       decoration: InputDecoration(
//         hintText: hint,
//         hintStyle: TextStyle(color: Colors.white54),
//         prefixIcon: Icon(Icons.lock, color: Colors.white),
//         suffixIcon: IconButton(
//           icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off, color: Colors.white),
//           onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
//         ),
//         filled: true,
//         fillColor: Color(0xFF3E2C5B),
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
//       ),
//       validator: (value) => value!.isEmpty ? "Password is required" : null,
//     );
//   }

//   Widget _buildPasswordField(String hint, TextEditingController controller) {
//     return TextFormField(
//       controller: controller,
//       obscureText: !_isPasswordVisible,
//       style: TextStyle(color: Colors.white),
//       decoration: InputDecoration(
//         hintText: hint,
//         hintStyle: TextStyle(color: Colors.white54),
//         prefixIcon: Icon(Icons.lock, color: Colors.white),
//         suffixIcon: IconButton(
//           icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off, color: Colors.white),
//           onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
//         ),
//         filled: true,
//         fillColor: Color(0xFF3E2C5B),
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
//       ),
//       validator: (value) => value!.isEmpty ? "Password is required" : null,
//     );
//   }
