import 'dart:ui';

import 'package:equatable/equatable.dart';

abstract class Curve extends Equatable {
  List<Offset> get points;

  const Curve();
}
