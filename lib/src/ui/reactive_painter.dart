import 'package:flutter/material.dart';
import 'package:sketcher/src/models/stroke.dart';
import 'package:sketcher/src/models/stroke_style.dart';
import 'package:sketcher/src/ui/bezier_path.dart';

class ReactivePainter extends ChangeNotifier implements CustomPainter {
  static const _moveThreshold = 2.0;

  // Color strokeColor;
  final _strokes = <Stroke>[];

  // double activeWeight = 1.5;
  // Color activeColor = Colors.green;
  final StrokeStyle? strokeStyle;

  ReactivePainter({required this.strokeStyle});

  List<Stroke> get strokes => _strokes;

  @override
  bool? hitTest(Offset position) => null;

  void startStroke(Offset position) {
    _strokes.add(
      Stroke(
        [position],
        strokeStyle!.color.withOpacity(strokeStyle!.opacity),
        strokeStyle!.weight,
      ),
    );
    notifyListeners();
  }

  void appendStroke(Offset position) {
    final stroke = _strokes.last;
    if (stroke.points.isEmpty) {
      stroke.points.add(position);
      notifyListeners();
    } else {
      if ((stroke.points.last - position).distance >= _moveThreshold) {
        stroke.points.add(position);
        notifyListeners();
      }
    }
  }

  Stroke endStroke() {
    notifyListeners();
    return _strokes.last;
  }

  static final strokePaint = Paint()
    ..color = Colors.black
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.4;

  @override
  void paint(Canvas canvas, Size size) {
    for (final stroke in _strokes) {
      BezierPath.paintBezierPath(canvas, stroke);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  @override
  SemanticsBuilderCallback? get semanticsBuilder => null;

  @override
  bool shouldRebuildSemantics(CustomPainter oldDelegate) {
    return false;
  }

  void clear() {
    _strokes.clear();
  }
}
