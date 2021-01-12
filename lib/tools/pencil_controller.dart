import 'package:flutter/widgets.dart';
import 'package:sketcher/tools/tool_controller.dart';
import 'package:sketcher/ui/operations/stroke_operation.dart';
import 'package:sketcher/ui/reactive_painter.dart';
import 'package:sketcher/ui/sketch_controller.dart';

class PencilController implements ToolController {
  final SketchController _sketchController;
  final OnStateUpdated _onStateUpdated;

  PencilController(this._sketchController, this._onStateUpdated);

  @override
  ReactivePainter toolPainter;

  @override
  void panStart(PointerDownEvent details) {
    toolPainter = ReactivePainter(_sketchController.activeToolStyle);
    toolPainter.startStroke(details.localPosition);
    _onStateUpdated();
  }

  @override
  void panUpdate(PointerMoveEvent details) {
    toolPainter.appendStroke(details.localPosition);
  }

  @override
  void panEnd(PointerUpEvent details) {
    final stroke = toolPainter.endStroke();
    toolPainter = null;
    final operation = StrokeOperation(stroke);
    _sketchController.commitOperation(operation);
    // _sketchController.reactivePainter.endStroke();
    // if (_sketchController.reactivePainter.strokes.length > 10) {
    //   _sketchController.commitStrokes();
    //   _onStateUpdated();
    // }
  }
}
