import 'package:sketcher/src/ui/static_painter.dart';

class SketchLayer {
  final int id;
  final StaticPainter painter;

  SketchLayer(this.id, this.painter);

  @override
  String toString() {
    return 'SketchLayer{id: $id, painter: $painter}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SketchLayer &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
