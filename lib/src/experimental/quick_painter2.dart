import 'package:flutter/material.dart';

// ignore: unused_element
class _QuickPainter2 extends ChangeNotifier implements CustomPainter {
  static final _paint = Paint()
    ..color = Colors.red
    ..style = PaintingStyle.stroke
    ..strokeWidth = 0.5;

//  final Offset _position;
  late _Touch _last;

  _QuickPainter2() : super();

  void append(_Touch touch) {
    _last = touch;
    notifyListeners();
  }

  @override
  void paint(Canvas canvas, Size size) {
    const lineSize = 20.0;
    canvas.drawLine(
      _last.offset.translate(-lineSize, 0),
      _last.offset.translate(lineSize, 0),
      _paint,
    );
    canvas.drawLine(
      _last.offset.translate(0, -lineSize),
      _last.offset.translate(0, lineSize),
      _paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  @override
  bool? hitTest(Offset position) => null;

  @override
  SemanticsBuilderCallback? get semanticsBuilder => null;

  @override
  bool shouldRebuildSemantics(CustomPainter oldDelegate) => false;
}

class _Touch {
  final Offset offset;
  final double pressure;

  _Touch(this.offset, this.pressure);
}
