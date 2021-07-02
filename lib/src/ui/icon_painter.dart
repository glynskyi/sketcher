import 'package:flutter/material.dart';
import 'dart:math';
class IconPainter extends CustomPainter {
  late Offset offset;
  late double radius;
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader=const RadialGradient(
        colors:[
          Colors.red,
          Colors.white,
        ],) .createShader(Rect.fromCircle(
        center: offset,
        radius: radius,
      ))
      //..color = Colors.deepOrangeAccent
      ..strokeWidth = 1
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      offset,
      radius,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;


}
