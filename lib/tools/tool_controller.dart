import 'package:flutter/gestures.dart';

typedef OnStateUpdated = void Function();

abstract class ToolController {
  void panStart(PointerDownEvent details);

  void panUpdate(PointerMoveEvent details);

  void panEnd(PointerUpEvent details);
}
