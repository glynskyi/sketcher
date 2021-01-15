import 'package:equatable/equatable.dart';
import 'package:sketcher/src/models/stroke.dart';
import 'package:sketcher/src/ui/operations/operation.dart';
import 'package:sketcher/src/ui/sketch_controller.dart';
import 'package:sketcher/src/ui/sketch_layer.dart';
import 'package:sketcher/src/ui/static_painter.dart';

/// A sketch operation for pencil or highlighter stroke.
class StrokeOperation extends Equatable implements Operation {
  final Stroke _stroke;
  final int _nextLayerId;

  const StrokeOperation(this._stroke, this._nextLayerId);

  @override
  List<Object> get props => [_stroke];

  @override
  void redo(SketchController controller) {
    final layer = SketchLayer(_nextLayerId, StaticPainter([_stroke]));
    controller.layers.add(layer);
    controller.notify();
  }

  @override
  void undo(SketchController controller) {
    controller.layers.removeLast();
    controller.notify();
  }
}
