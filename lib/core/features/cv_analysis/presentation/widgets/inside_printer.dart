import 'package:flutter/material.dart';

class InsideVectorPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.white // Inner line color
      ..strokeWidth = 2 // Line thickness
      ..style = PaintingStyle.stroke;

    final Path path = Path();

    // Draw the inside vertical line slightly offset from the center
    double padding = size.width * 0.3; // Adjust the position of the inner line

    // Draw the opposite vertical line
    path.moveTo(size.width - padding, size.height * 0.01);
    path.lineTo(size.width - padding, size.height * 0.99);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
