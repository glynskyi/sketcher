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
// class IconPainter extends CustomPainter {
//   var myPaint = Paint()
//     ..color = Colors.black
//     ..style = PaintingStyle.stroke
//     ..strokeWidth = 5.0;
//
//   double radius = 80;
//  // Offset offset;
//   @override
//   void paint(Canvas canvas, Size size) {
//     int n = 10;
//     var range = List<int>.generate(n, (i) => i + 1);
//     for (int i in range) {
//       double x = 2 * pi / n;
//       double dx = radius * cos(i * x);
//       double dy = radius * sin(i * x);
//       canvas.drawCircle(Offset(dx, dy), radius, myPaint);
//     }
//   }
//
//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) {
//     return true;
//   }
// }
//
