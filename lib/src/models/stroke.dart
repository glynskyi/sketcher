import 'package:flutter/painting.dart';
import 'package:sketcher/src/models/curve.dart';

/// A pencil or highlighter stroke. Contains a list of points that belong to it.
class Stroke extends Curve {
  @override
  final List<Offset> points;
  final Color color;
  final double weight;

  const Stroke(this.points, this.color, this.weight);

  @override
  List<Object> get props => [points, color, weight];

  @override
  String toString() {
    return "Stroke { ${points.length}p }";
  }
}
