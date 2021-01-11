import 'package:flutter/material.dart';
import 'package:sketcher/models/stroke.dart';
import 'package:sketcher/ui/bezier_path.dart';

class ReactivePainter extends ChangeNotifier implements CustomPainter {
  Color strokeColor;
  final _strokes = <Stroke>[];
  double activeWeight = 1.5;
  Color activeColor = Colors.green;

  ReactivePainter(this.strokeColor);

  List<Stroke> get strokes => _strokes;

  @override
  bool hitTest(Offset position) => null;

  void startStroke(Offset position) {
    _strokes.add(Stroke([position], activeColor, activeWeight));
    notifyListeners();
  }

  void appendStroke(Offset position) {
    final stroke = _strokes.last;
    stroke.points.add(position);
    notifyListeners();
  }

  void endStroke() {
    notifyListeners();
  }

  static final strokePaint = Paint()
    ..color = Colors.black
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.4;

  @override
  void paint(Canvas canvas, Size size) {
    for (var stroke in _strokes) {
      BezierPath.paintBezierPath(canvas, stroke);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  @override
  SemanticsBuilderCallback get semanticsBuilder => null;

  @override
  bool shouldRebuildSemantics(CustomPainter oldDelegate) {
    return false;
  }

  void clear() {
    _strokes.clear();
  }
}
