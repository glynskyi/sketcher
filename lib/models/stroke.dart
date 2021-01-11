import 'package:flutter/painting.dart';

class Stroke {
  final List<Offset> points;
  final Color color;
  final double weight;

  bool isDeleted = false;

  Stroke(this.points, this.color, this.weight);

  @override
  String toString() {
    return "Stroke { ${points.length}p }";
  }
}
