import 'package:flutter/material.dart';

// ignore: unused_element
class _PaperPainter extends CustomPainter {
  final ValueNotifier<double> scrollNotifier;

  _PaperPainter(this.scrollNotifier) : super(repaint: scrollNotifier);

  static final _paint = Paint()
    ..style = PaintingStyle.fill
    ..color = Colors.grey.shade300;

  @override
  void paint(Canvas canvas, Size size) {
    const gap = 20;
    final offset = scrollNotifier.value % gap;
    for (var i = 0; i < size.width; i += gap) {
      for (var e = 0; e < size.height; e += gap) {
        canvas.drawCircle(
          Offset(i.toDouble(), e.toDouble() + gap - offset),
          1.2,
          _paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
