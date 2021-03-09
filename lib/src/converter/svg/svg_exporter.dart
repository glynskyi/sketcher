import 'dart:ui';

import 'package:sketcher/src/converter/exporter.dart';
import 'package:sketcher/src/models/curve.dart';
import 'package:sketcher/src/models/path_curve.dart';
import 'package:sketcher/src/models/stroke.dart';
import 'package:sketcher/src/ui/sketch_controller.dart';
import 'package:xml/xml.dart';

/// A utility class for decoding a [SketchController] to SVG data
class SvgExporter implements Exporter {
  @override
  String export(SketchController controller,
      {bool exportBackgroundColor = false}) {
    final builder = XmlBuilder();
    builder.processing('xml', 'version="1.0"');
    builder.element("svg", nest: () {
      if (exportBackgroundColor) {
        builder.attribute("viewport-fill",
            _flutterColorToSvgColor(controller.backgroundColor.value));
      }
      _exportViewBox(builder, controller);
      for (final layer in controller.layers) {
        for (final stroke in layer.painter.curves) {
          _toPath(builder, stroke);
        }
      }
    });
    return builder.buildDocument().outerXml;
  }

  bool _exportViewBox(XmlBuilder builder, SketchController controller) {
    try {
      final overallRect = controller.layers.map((layer) {
        return layer.painter.curves.map((curve) {
          return curve.points
              .map((offset) => Rect.fromPoints(Offset.zero, offset))
              .reduce(_expandToInclude);
        }).reduce(_expandToInclude);
      }).reduce(_expandToInclude);
      final width = overallRect.width.ceil();
      final height = overallRect.height.ceil();
      builder.attribute("width", width);
      builder.attribute("height", height);
      builder.attribute("viewBox", "0 0 $width $height");
      return true;
    } on Object {
      // doesn't have enough points to calculate a view box
      return false;
    }
  }

  Rect _expandToInclude(Rect rect1, Rect rect2) {
    return rect1.expandToInclude(rect2);
  }

  void _toPath(XmlBuilder builder, Curve curve) {
    if (curve is PathCurve) {
      builder.element(
        "path",
        attributes: {
          for (var attr in curve.originPath.attributes)
            attr.name.local: attr.value,
        },
      );
    } else if (curve is Stroke) {
      final d = StringBuffer();
      d.write(
          "M${curve.points.first.dx.toInt()} ${curve.points.first.dy.toInt()}");
      for (final point in curve.points.skip(1)) {
        d.write(" L${point.dx.toInt()} ${point.dy.toInt()}");
      }
      builder.element("path", attributes: {
        "d": d.toString(),
        "stroke": _flutterColorToSvgColor(curve.color.value),
        "stroke-opacity": curve.color.opacity.toString(),
        "stroke-width": curve.weight.toStringAsFixed(0),
        "stroke-linecap": "round",
        "fill": "none"
      });
    } else {
      throw ArgumentError.value(curve, "curve", "Unknown curve type");
    }
  }

  static String _flutterColorToSvgColor(int color) {
    final fullColor = color.toRadixString(16).toUpperCase().padLeft(8, "0");
    final onlyColor = fullColor.substring(fullColor.length - 6);
    return "#$onlyColor";
  }
}
