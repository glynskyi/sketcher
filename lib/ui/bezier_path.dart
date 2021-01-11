import 'package:flutter/painting.dart';
import 'package:sketcher/models/stroke.dart';

class BezierPath {
  BezierPath._();

  static void paintBezierPath(Canvas canvas, Stroke stroke) {
    if (stroke.isDeleted) {
      return;
    }
    try {
      final knots = stroke.points.map((offset) => EPointF(offset.dx, offset.dy)).toList();
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
          appendCurveToPath(polyBezierPath, controlPoints[i], controlPoints[n + i], targetKnot);
        }
      }
      // polyBezierPath.lineTo(firstKnot.getX(), firstKnot.getY());

      final _paint = Paint()
        ..color = stroke.color
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = stroke.weight;

      canvas.drawPath(polyBezierPath, _paint);
      // !!! return polyBezierPath;
    } on Object catch (ex, stacktrace) {
      print("paintBezierPath, ex: $ex, stacktrace: $stacktrace");
//      print(e);
//      print(stacktrace);
    }
  }

  static List<EPointF> computeControlPoints(int n, List<EPointF> knots) {
    final result = List<EPointF>.filled(2 * n, null);

    final target = constructTargetVector(n, knots);
    final lowerDiag = constructLowerDiagonalVector(n - 1);
    final mainDiag = constructMainDiagonalVector(n);
    final upperDiag = constructUpperDiagonalVector(n - 1);

    final newTarget = List<EPointF>.filled(n, null);
    final newUpperDiag = List<double>.filled(n - 1, null);

    // forward sweep for control points c_i,0:
    newUpperDiag[0] = upperDiag[0] / mainDiag[0];
    newTarget[0] = target[0].scaleBy(1 / mainDiag[0]);

    for (var i = 1; i < n - 1; i++) {
      newUpperDiag[i] = upperDiag[i] / (mainDiag[i] - lowerDiag[i - 1] * newUpperDiag[i - 1]);
    }

    for (var i = 1; i < n; i++) {
      final targetScale = 1 / (mainDiag[i] - lowerDiag[i - 1] * newUpperDiag[i - 1]);

      newTarget[i] = (target[i].minus(newTarget[i - 1].scaleBy(lowerDiag[i - 1]))).scaleBy(targetScale);
    }

    // backward sweep for control points c_i,0:
    result[n - 1] = newTarget[n - 1];

    for (var i = n - 2; i >= 0; i--) {
      result[i] = newTarget[i].minus(result[i + 1], newUpperDiag[i]);
    }

    // calculate remaining control points c_i,1 directly:
    for (var i = 0; i < n - 1; i++) {
      result[n + i] = knots[i + 1].scaleBy(2).minus(result[i + 1]);
    }

    result[2 * n - 1] = knots[n].plus(result[n - 1]).scaleBy(0.5);

    return result;
  }

  static List<EPointF> constructTargetVector(int n, List<EPointF> knots) {
    final result = List<EPointF>.filled(n, null);

    result[0] = knots[0].plus(knots[1], 2);

    for (var i = 1; i < n - 1; i++) {
      result[i] = (knots[i].scaleBy(2).plus(knots[i + 1])).scaleBy(2);
    }

    result[result.length - 1] = knots[n - 1].scaleBy(8).plus(knots[n]);

    return result;
  }

  static List<double> constructLowerDiagonalVector(int length) {
    final result = List<double>.filled(length, null);

    for (var i = 0; i < result.length - 1; i++) {
      result[i] = 1.0;
    }

    result[result.length - 1] = 2.0;

    return result;
  }

  static List<double> constructMainDiagonalVector(int n) {
    final result = List<double>.filled(n, null);

    result[0] = 2.0;

    for (var i = 1; i < result.length - 1; i++) {
      result[i] = 4.0;
    }

    result[result.length - 1] = 7.0;

    return result;
  }

  static List<double> constructUpperDiagonalVector(int length) {
    final result = List<double>.filled(length, null);

    for (var i = 0; i < result.length; i++) {
      result[i] = 1.0;
    }

    return result;
  }

  static void appendCurveToPath(Path path, EPointF control1, EPointF control2, EPointF targetKnot) {
    path.cubicTo(
        control1.getX(), control1.getY(), control2.getX(), control2.getY(), targetKnot.getX(), targetKnot.getY());
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
