import 'package:flutter/painting.dart';

class StrokeStyle {
  final double opacity;
  final Color color;
  final double weight;

  StrokeStyle(this.opacity, this.color, this.weight);

  StrokeStyle copy({double opacity, Color color, double weight}) {
    return StrokeStyle(
        opacity ?? this.opacity, color ?? this.color, weight ?? this.weight);
  }
}
