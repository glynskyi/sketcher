import 'package:sketcher/src/converter/exporter.dart';
import 'package:sketcher/src/models/stroke.dart';
import 'package:sketcher/src/ui/sketch_controller.dart';
import 'package:xml/xml.dart';

/// A utility class for decoding a [SketchController] to SVG data
class SvgExporter implements Exporter {
  @override
  String export(SketchController controller) {
    final builder = XmlBuilder();
    builder.processing('xml', 'version="1.0"');
    builder.element("svg", nest: () {
      builder.attribute("viewport-fill",
          _flutterColorToSvgColor(controller.backgroundColor.value));
      for (var layer in controller.layers) {
        for (var stroke in layer.painter.strokes) {
          _toPath(builder, stroke);
        }
      }
    });
    return builder.buildDocument().outerXml;
  }

  void _toPath(XmlBuilder builder, Stroke stroke) {
    var d =
        "M${stroke.points.first.dx.toInt()} ${stroke.points.first.dy.toInt()}";
    for (var point in stroke.points.skip(1)) {
      d += " L${point.dx.toInt()} ${point.dy.toInt()}";
    }
    builder.element("path", attributes: {
      "d": d,
      "stroke": _flutterColorToSvgColor(stroke.color.value),
      "stroke-opacity": stroke.color.opacity.toString(),
      "stroke-width": stroke.weight.toStringAsFixed(0),
      "fill": "none"
    });
  }

  static String _flutterColorToSvgColor(int color) {
    final fullColor = color.toRadixString(16).toUpperCase().padLeft(8, "0");
    final onlyColor = fullColor.substring(fullColor.length - 6);
    return "#$onlyColor";
  }
}
