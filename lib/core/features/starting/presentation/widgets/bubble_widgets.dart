import 'package:flutter/material.dart';

Widget smallBubble(double size) {
  return Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: Colors.white.withOpacity(0.3),
    ),
  );
}

Widget bubbleWithText(double size) {
  return Container(
    width: 140,
    height: 55,
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.3),
      borderRadius: BorderRadius.circular(25),
    ),
    child: Center(
      child: Text(
        "Need our help now?",
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white70,
        ),
      ),
    ),
  );
}

