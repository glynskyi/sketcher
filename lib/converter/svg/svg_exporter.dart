import 'package:sketcher/converter/exporter.dart';
import 'package:sketcher/models/stroke.dart';
import 'package:sketcher/sketcher.dart';
import 'package:xml/xml.dart';

class SvgExporter implements Exporter {
  @override
  String export(SketchController controller) {
    final builder = XmlBuilder();
    builder.processing('xml', 'version="1.0"');
    builder.element("svg", nest: () {
      for (var painter in controller.staticPainters) {
        for (var stroke in painter.strokes) {
          _toPath(builder, stroke);
        }
      }
      for (var stroke in controller.reactivePainter.strokes) {
        _toPath(builder, stroke);
      }
    });
    final svg = builder.buildDocument().outerXml;
    print(svg);
    return svg;
  }

  void _toPath(XmlBuilder builder, Stroke stroke) {
    var d = "M${stroke.points.first.dx.toInt()} ${stroke.points.first.dy.toInt()}";
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
    final fullColor = color.toRadixString(16);
    final onlyColor = fullColor.substring(fullColor.length - 6);
    return "#$onlyColor";
  }
}
