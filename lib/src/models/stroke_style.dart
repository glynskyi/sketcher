import 'package:equatable/equatable.dart';
import 'package:flutter/painting.dart';

/// A style container that provides information to render the stroke
class StrokeStyle extends Equatable {
  final double opacity;
  final Color color;
  final double weight;

  const StrokeStyle(this.opacity, this.color, this.weight);

  @override
  List<Object> get props => [opacity, color, weight];

  StrokeStyle copy({
    double? opacity,
    Color? color,
    double? weight,
  }) {
    return StrokeStyle(
      opacity ?? this.opacity,
      color ?? this.color,
      weight ?? this.weight,
    );
  }
}
