import 'dart:ui';

import 'package:equatable/equatable.dart';

abstract class Curve extends Equatable {
  List<Offset> get points;

  const Curve();
}

extension CurveExtension on Curve {
  Rect get bounds =>
      points.fold(Rect.fromPoints(points.first, points.first), (bounds, point) {
        return bounds.expandToInclude(Rect.fromPoints(point, point));
      });
}
