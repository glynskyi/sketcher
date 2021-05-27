import 'package:flutter/rendering.dart';
import 'package:sketcher/src/models/curve.dart';
import 'package:sketcher/src/models/path_curve.dart';
import 'package:sketcher/src/models/stroke.dart';
import 'package:sketcher/src/ui/bezier_path.dart';

class StaticPainter extends CustomPainter {
  final List<Curve> curves;
  final Rect bounds;

  StaticPainter(this.curves)
      : bounds = curves.fold<Rect>(const Rect.fromLTWH(0, 0, 0, 0),
            (bounds, curve) => bounds.expandToInclude(curve.bounds));

  @override
  void paint(Canvas canvas, Size size) {
    for (final curve in curves) {
      if (curve is Stroke) {
        BezierPath.paintBezierPath(canvas, curve);
      } else if (curve is PathCurve) {
        canvas.drawPath(
          curve.path,
          Paint()
            ..color = curve.color
            ..style = curve.style
            ..strokeWidth = curve.stokeWidth,
        );
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  @override
  String toString() {
    return "StaticPainter {$curves}";
  }
}
