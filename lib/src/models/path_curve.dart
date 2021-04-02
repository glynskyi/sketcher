import 'dart:ui';

import 'package:flutter_svg/src/svg/colors.dart'; // ignore: implementation_imports
import 'package:ktx/ktx.dart';
import 'package:path_parsing/path_parsing.dart';
import 'package:xml/xml.dart';

import 'curve.dart';

class PathCurve extends Curve {
  final XmlNode originPath;
  @override
  late final List<Offset> points;
  late final Color color;
  late final Path path;
  late final PaintingStyle style;
  late final double stokeWidth;

  PathCurve(this.originPath) {
    final visitor = _PathVisitor();
    // fill path
    if (originPath.getAttribute("fill") != null &&
        originPath.getAttribute("fill") != "none") {
      style = PaintingStyle.fill;
      stokeWidth = 0;
      final rawColor = parseColor(originPath.getAttribute("fill"));
      final opacity =
          originPath.getAttribute("fill-opacity")?.let(double.parse);
      color = rawColor?.withOpacity(opacity ?? 1) ??
          const Color.fromARGB(255, 0, 0, 0);
    }
    // stoke path
    else if (originPath.getAttribute("stroke") != null &&
        originPath.getAttribute("stroke") != "none") {
      style = PaintingStyle.stroke;
      stokeWidth =
          originPath.getAttribute("stroke-width")?.let(double.parse) ?? 1;
      final rawColor = parseColor(originPath.getAttribute("stroke"));
      final opacity =
          originPath.getAttribute("stroke-opacity")?.let(double.parse);
      color = rawColor?.withOpacity(opacity ?? 1) ??
          const Color.fromARGB(255, 0, 0, 0);
    }
    // default path
    else {
      style = PaintingStyle.stroke;
      stokeWidth = 1;
      color = const Color.fromARGB(255, 255, 0, 0);
    }
    writeSvgPathDataToPath(originPath.getAttribute("d"), visitor);
    path = visitor.path;
    points = visitor.points;
  }

  @override
  List<Object?> get props => [points, color];
}

class _PathVisitor extends PathProxy {
  final path = Path();
  final points = <Offset>[];

  _PathVisitor();

  @override
  void close() {
    path.close();
  }

  @override
  void cubicTo(
    double x1,
    double y1,
    double x2,
    double y2,
    double x3,
    double y3,
  ) {
    path.cubicTo(x1, y1, x2, y2, x3, y3);
    points.add(Offset(x1, y1));
  }

  @override
  void lineTo(double x, double y) {
    path.lineTo(x, y);
    points.add(Offset(x, y));
  }

  @override
  void moveTo(double x, double y) {
    path.moveTo(x, y);
    points.add(Offset(x, y));
  }
}
