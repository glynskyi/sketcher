import 'package:flutter/material.dart';
import 'package:sketcher/models/stroke.dart';
import 'package:sketcher/ui/bezier_path.dart';

class StaticPainter extends CustomPainter {
  final List<Stroke> strokes;

  StaticPainter(this.strokes);

  @override
  void paint(Canvas canvas, Size size) {
    for (var stroke in strokes) {
      BezierPath.paintBezierPath(canvas, stroke);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  @override
  String toString() {
    return "StaticPainter {$strokes}";
  }
}
