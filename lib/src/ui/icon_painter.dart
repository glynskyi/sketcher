import 'package:flutter/material.dart';
import 'dart:math';
class IconPainter extends CustomPainter {
  late Offset offset;
  late double radius;
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(
      offset,
      radius,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;


}
