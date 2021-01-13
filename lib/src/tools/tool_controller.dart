import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';

typedef OnStateUpdated = void Function();

abstract class ToolController {
  CustomPainter get toolPainter;

  void panStart(PointerDownEvent details);

  void panUpdate(PointerMoveEvent details);

  void panEnd(PointerUpEvent details);
}
