import 'package:flutter/material.dart';

// ignore: unused_element
class _QuickPainter extends ChangeNotifier implements CustomPainter {
  static final _paint = Paint()
    ..color = Colors.black
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.5;

//  final Offset _position;
  final List<_Touch> _allPoints = [];

  _QuickPainter() : super();

  void append(_Touch touch) {
    _allPoints.add(touch);
    notifyListeners();
  }

  @override
  void paint(Canvas canvas, Size size) {
//    canvas.drawLine(
//        Offset(0, _position.dy), Offset(size.width, _position.dy), _paint);
//    canvas.drawLine(
//        Offset(_position.dx, 0), Offset(_position.dx, size.height), _paint);

//    var _originalDataSeries = _allPoints.map((offset) => Point(offset.dx, offset.dy)).toList();
//    var _sampledCurve = _originalDataSeries.getSampledCurveFromPoints(10);
//  for (var i = 0; i < _allPoints.length - 1; i++) {
//    final prev = _allPoints[i];
//    final next = _allPoints[i+1];
//    canvas.drawCircle(
//        Offset(point.offset.dx, point.offset.dy), 1 + point.pressure, _paint);
//    _paint.strokeWidth = 1 + next.pressure;
//    _paint.strokeCap = StrokeCap.round;
//    canvas.drawLine(prev.offset, next.offset, _paint);

    final knots = _allPoints
        .map((point) => EPointF(point.offset.dx, point.offset.dy))
        .toList();
    if (knots.isEmpty) return;

    final polyBezierPath = Path();
    final firstKnot = knots[0];
    polyBezierPath.moveTo(firstKnot.getX(), firstKnot.getY());

    /*
     * variable representing the number of Bezier curves we will join
     * together
     */
    final n = knots.length - 1;

    if (n == 1) {
      final lastKnot = knots[1];
      polyBezierPath.lineTo(lastKnot.getX(), lastKnot.getY());
    } else {
      final controlPoints = computeControlPoints(n, knots);

      for (var i = 0; i < n; i++) {
        final targetKnot = knots[i + 1];
        appendCurveToPath(
          polyBezierPath,
          controlPoints[i],
          controlPoints[n + i],
          targetKnot,
        );
      }
    }

    // polyBezierPath.lineTo(firstKnot.getX(), firstKnot.getY());
    canvas.drawPath(polyBezierPath, _paint);
    // !!! return polyBezierPath;
  }

  List<EPointF> computeControlPoints(int n, List<EPointF> knots) {
    final result = List<EPointF?>.filled(2 * n, null);

    final target = constructTargetVector(n, knots);
    final lowerDiag = constructLowerDiagonalVector(n - 1);
    final mainDiag = constructMainDiagonalVector(n);
    final upperDiag = constructUpperDiagonalVector(n - 1);

    final newTarget = List<EPointF?>.filled(n, null);
    final newUpperDiag = List<double?>.filled(n - 1, null);

    // forward sweep for control points c_i,0:
    newUpperDiag[0] = upperDiag[0] / mainDiag[0];
    newTarget[0] = target[0].scaleBy(1 / mainDiag[0]);

    for (var i = 1; i < n - 1; i++) {
      newUpperDiag[i] = upperDiag[i] /
          (mainDiag[i] - lowerDiag[i - 1] * newUpperDiag[i - 1]!);
    }

    for (var i = 1; i < n; i++) {
      final targetScale =
          1 / (mainDiag[i] - lowerDiag[i - 1] * newUpperDiag[i - 1]!);

      newTarget[i] =
          (target[i].minus(newTarget[i - 1]!.scaleBy(lowerDiag[i - 1])))
              .scaleBy(targetScale);
    }

    // backward sweep for control points c_i,0:
    result[n - 1] = newTarget[n - 1];

    for (var i = n - 2; i >= 0; i--) {
      result[i] = newTarget[i]!.minus(result[i + 1]!, newUpperDiag[i]!);
    }

    // calculate remaining control points c_i,1 directly:
    for (var i = 0; i < n - 1; i++) {
      result[n + i] = knots[i + 1].scaleBy(2).minus(result[i + 1]!);
    }

    result[2 * n - 1] = knots[n].plus(result[n - 1]!).scaleBy(0.5);

    return result as List<EPointF>;
  }

  List<EPointF> constructTargetVector(int n, List<EPointF> knots) {
    final result = List<EPointF?>.filled(n, null);

    result[0] = knots[0].plus(knots[1], 2);

    for (var i = 1; i < n - 1; i++) {
      result[i] = (knots[i].scaleBy(2).plus(knots[i + 1])).scaleBy(2);
    }

    result[result.length - 1] = knots[n - 1].scaleBy(8).plus(knots[n]);

    return result as List<EPointF>;
  }

  List<double> constructLowerDiagonalVector(int length) {
    final result = List<double?>.filled(length, null);

    for (var i = 0; i < result.length - 1; i++) {
      result[i] = 1.0;
    }

    result[result.length - 1] = 2.0;

    return result as List<double>;
  }

  List<double> constructMainDiagonalVector(int n) {
    final result = List<double?>.filled(n, null);

    result[0] = 2.0;

    for (var i = 1; i < result.length - 1; i++) {
      result[i] = 4.0;
    }

    result[result.length - 1] = 7.0;

    return result as List<double>;
  }

  List<double> constructUpperDiagonalVector(int length) {
    final result = List<double?>.filled(length, null);

    for (var i = 0; i < result.length; i++) {
      result[i] = 1.0;
    }

    return result as List<double>;
  }

  void appendCurveToPath(
    Path path,
    EPointF control1,
    EPointF control2,
    EPointF targetKnot,
  ) {
    path.cubicTo(
      control1.getX(),
      control1.getY(),
      control2.getX(),
      control2.getY(),
      targetKnot.getX(),
      targetKnot.getY(),
    );
  }

//    for (var point in _allPoints) {
//      canvas.drawCircle(
//          Offset(point.offset.dx, point.offset.dy), 1 + point.pressure, _paint);
//    }
//    final rawPoints = _allPoints.map((point) => vmath.Vector2(point.dx, point.dy)).toList();
//    final curve = Bezier.fromPoints(rawPoints);
//  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return _allPoints == (oldDelegate as _QuickPainter)._allPoints;
  }

  @override
  bool? hitTest(Offset position) => null;

  @override
  SemanticsBuilderCallback? get semanticsBuilder => null;

  @override
  bool shouldRebuildSemantics(CustomPainter oldDelegate) => false;

  List<_Touch> points() => _allPoints;

  void clear() {
    _allPoints.clear();
  }
}

class EPointF {
  final double x;
  final double y;

  EPointF(this.x, this.y);

  double getX() {
    return x;
  }

  double getY() {
    return y;
  }

  EPointF plus(EPointF ePointF, [double factor = 1.0]) {
    return EPointF(x + factor * ePointF.x, y + factor * ePointF.y);
  }

  EPointF minus(EPointF ePointF, [double factor = 1.0]) {
    return EPointF(x - factor * ePointF.x, y - factor * ePointF.y);
  }

  EPointF scaleBy(double factor) {
    return EPointF(factor * x, factor * y);
  }
}

class _Touch {
  final Offset offset;
  final double pressure;

  _Touch(this.offset, this.pressure);
}
