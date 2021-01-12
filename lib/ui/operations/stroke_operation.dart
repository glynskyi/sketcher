import 'package:sketcher/models/stroke.dart';
import 'package:sketcher/ui/operations/operation.dart';
import 'package:sketcher/ui/sketch_controller.dart';
import 'package:sketcher/ui/sketch_layer.dart';
import 'package:sketcher/ui/static_painter.dart';

class StrokeOperation implements Operation {
  final Stroke _stroke;

  StrokeOperation(this._stroke);

  @override
  void redo(SketchController controller) {
    final layer = SketchLayer(controller.nextLayerId, StaticPainter([_stroke]));
    controller.layers.add(layer);
    controller.notify();
  }

  @override
  void undo(SketchController controller) {
    controller.layers.removeLast();
    controller.notify();
  }
}
