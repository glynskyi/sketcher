import 'package:sketcher/src/models/curve.dart';
import 'package:sketcher/src/ui/operations/operation.dart';
import 'package:sketcher/src/ui/sketch_controller.dart';
import 'package:sketcher/src/ui/sketch_layer.dart';
import 'package:sketcher/src/ui/static_painter.dart';

class EraserOperation implements Operation {
  final SketchLayer _originLayer;
  final List<Curve> _aliveStrokes;
  final int _nextLayerId;

  EraserOperation(this._originLayer, this._aliveStrokes, this._nextLayerId);

  @override
  void redo(SketchController controller) {
    final painter = StaticPainter(_aliveStrokes);
    final layer = SketchLayer(_nextLayerId, painter);
    final index = controller.layers.indexOf(_originLayer);
    controller.layers[index] = layer;
    controller.notify();
  }

  @override
  void undo(SketchController controller) {
    final index =
        controller.layers.indexWhere((layer) => layer.id == _nextLayerId);
    controller.layers[index] = _originLayer;
    controller.notify();
  }
}
