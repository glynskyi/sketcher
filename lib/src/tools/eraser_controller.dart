import 'package:flutter/rendering.dart';
import 'package:sketcher/src/models/curve.dart';
import 'package:sketcher/src/tools/tool_controller.dart';
import 'package:sketcher/src/ui/operations/eraser_operation.dart';
import 'package:sketcher/src/ui/reactive_painter.dart';
import 'package:sketcher/src/ui/sketch_controller.dart';
import 'package:sketcher/src/ui/sketch_layer.dart';

class EraserController implements ToolController {
  final SketchController _sketchController;
  final OnStateUpdated _onStateUpdated;
  final int _tolerance = 10;

  @override
  ReactivePainter? toolPainter;

  EraserController(this._sketchController, this._onStateUpdated);

  @override
  void panStart(PointerDownEvent details) {
    // toolPainter = ReactivePainter(_sketchController.activeToolStyle);
    // if (_sketchController.commitStrokes()) {
    //   _onStateUpdated();
    // }
    _onStateUpdated();
    _searchDeleteStroke(details.localPosition);
  }

  @override
  void panUpdate(PointerMoveEvent details) {
    _searchDeleteStroke(details.localPosition);
  }

  @override
  void panEnd(PointerUpEvent details) {
    _searchDeleteStroke(details.localPosition);
  }

  void _searchDeleteStroke(Offset offset) {
    final layers =
        List<SketchLayer>.from(_sketchController.layers, growable: false);
    for (final layer in layers) {
      final aliveCurves = <Curve>[];
      final deletedCurves = <Curve>[];
      for (final curve in layer.painter.curves) {
        final isAffected =
            curve.points.any((point) => (offset - point).distance < _tolerance);
        if (isAffected) {
          deletedCurves.add(curve);
        } else {
          aliveCurves.add(curve);
        }
      }
      if (deletedCurves.isNotEmpty) {
        final operation =
            EraserOperation(layer, aliveCurves, _sketchController.nextLayerId);
        _sketchController.commitOperation(operation);
      }
    }
  }

  @override
  void panReset() {
    toolPainter = null;
  }
}
