import 'package:flutter/material.dart';

// ignore: unused_element
class _PredictionArena extends StatefulWidget {
  @override
  _PredictionArenaState createState() => _PredictionArenaState();
}

class _PredictionArenaState extends State<_PredictionArena> {
  final PredictionPainter _painter = PredictionPainter();

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: onPointerDown,
      onPointerMove: onPointerMove,
      onPointerUp: onPointerUp,
      child: CustomPaint(size: const Size(double.infinity, double.infinity), painter: _painter),
    );
  }

  void onPointerDown(PointerDownEvent event) {
    _painter.setCurrent(event.localPosition);
  }

  void onPointerMove(PointerMoveEvent event) {
    _painter.setCurrent(event.localPosition);
  }

  void onPointerUp(PointerUpEvent event) {
    _painter.setCurrent(event.localPosition);
  }
}

class PredictionPainter extends ChangeNotifier implements CustomPainter {
  Offset current = Offset.zero;
  static final _paint = Paint()
    ..color = Colors.red
    ..style = PaintingStyle.fill;

  PredictionPainter();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(current, 2, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return (oldDelegate as PredictionPainter).current != current;
  }

  @override
  bool hitTest(Offset position) => null;

  @override
  SemanticsBuilderCallback get semanticsBuilder => null;

  @override
  bool shouldRebuildSemantics(CustomPainter oldDelegate) => false;

  void setCurrent(Offset localPosition) {
    current = localPosition;
    notifyListeners();
  }
}
