import 'package:flutter/widgets.dart';
import 'package:sketcher/tools/tool_controller.dart';
import 'package:sketcher/ui/sketch_controller.dart';

class PencilController implements ToolController {
  final SketchController _sketchController;
  final OnStateUpdated _onStateUpdated;

  PencilController(this._sketchController, this._onStateUpdated);

  @override
  void panStart(PointerDownEvent details) {
    _sketchController.reactivePainter.startStroke(details.localPosition);
  }

  @override
  void panUpdate(PointerMoveEvent details) {
    _sketchController.reactivePainter.appendStroke(details.localPosition);
  }

  @override
  void panEnd(PointerUpEvent details) {
    _sketchController.reactivePainter.endStroke();
    if (_sketchController.reactivePainter.strokes.length > 10) {
      _sketchController.commitStrokes();
      _onStateUpdated();
    }
  }
}
