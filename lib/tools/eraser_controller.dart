import 'package:flutter/rendering.dart';
import 'package:sketcher/tools/tool_controller.dart';
import 'package:sketcher/ui/sketch_controller.dart';
import 'package:sketcher/ui/static_painter.dart';

class EraserController implements ToolController {
  final SketchController _sketchController;
  final OnStateUpdated _onStateUpdated;
  final int _tolerance = 10;

  EraserController(this._sketchController, this._onStateUpdated);

  @override
  void panStart(PointerDownEvent details) {
    if (_sketchController.commitStrokes()) {
      _onStateUpdated();
    }
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
    final staticPainters = List<StaticPainter>.from(_sketchController.staticPainters, growable: false);
    for (var staticPainter in staticPainters) {
      final deletingStokes = staticPainter.strokes
          .where((stroke) => !stroke.isDeleted)
          .where((stroke) => stroke.points.any((point) => (offset - point).distance < _tolerance))
          .toList(growable: false);
      if (deletingStokes.isNotEmpty) {
        deletingStokes.forEach((stroke) => stroke.isDeleted = true);
        _sketchController.staticPainters.remove(staticPainter);
        final aliveStrokes = staticPainter.strokes.where((stroke) => !stroke.isDeleted).toList(growable: true);
        _sketchController.staticPainters.add(StaticPainter(aliveStrokes));
        _onStateUpdated();
        _sketchController.notify();
      }
    }
  }
}
