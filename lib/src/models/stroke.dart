import 'package:equatable/equatable.dart';
import 'package:flutter/painting.dart';

/// A pencil or highlighter stroke. Contains a list of points that belong to it.
class Stroke extends Equatable {
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
