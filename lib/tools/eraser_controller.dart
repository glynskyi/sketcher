import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:sketcher/models/stroke.dart';
import 'package:sketcher/tools/tool_controller.dart';
import 'package:sketcher/ui/operations/eraser_operation.dart';
import 'package:sketcher/ui/reactive_painter.dart';
import 'package:sketcher/ui/sketch_controller.dart';
import 'package:sketcher/ui/sketch_layer.dart';

class EraserController implements ToolController {
  final SketchController _sketchController;
  final OnStateUpdated _onStateUpdated;
  final int _tolerance = 10;

  @override
  ReactivePainter toolPainter;

  EraserController(this._sketchController, this._onStateUpdated);

  @override
  void panStart(PointerDownEvent details) {
    toolPainter = ReactivePainter(_sketchController.activeToolStyle);
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
    final layers = List<SketchLayer>.from(_sketchController.layers, growable: false);
    for (var layer in layers) {
      final aliveStrokes = <Stroke>[];
      final deletedStrokes = <Stroke>[];
      for (var stroke in layer.painter.strokes) {
        final isAffected = stroke.points.any((point) => (offset - point).distance < _tolerance);
        if (isAffected) {
          deletedStrokes.add(stroke);
        } else {
          aliveStrokes.add(stroke);
        }
      }
      if (deletedStrokes.isNotEmpty) {
        // final layer = Layer(_sketchController.)
        final operation = EraserOperation(layer, aliveStrokes, _sketchController.nextLayerId);
        _sketchController.commitOperation(operation);
      }
      // final deletingStokes = layer.painter.strokes
      //     .where((stroke) => !stroke.isDeleted)
      //     .where((stroke) => )
      //     .toList(growable: false);
      // if (deletingStokes.isNotEmpty) {
      //   deletingStokes.forEach((stroke) => stroke.isDeleted = true);
      //   _sketchController.staticPainters.remove(staticPainter);
      //   final aliveStrokes = staticPainter.strokes.where((stroke) => !stroke.isDeleted).toList(growable: true);
      //   _sketchController.staticPainters.add(StaticPainter(aliveStrokes));
      //   _onStateUpdated();
      //   _sketchController.notify();
      // }
    }
  }
}
