import 'package:flutter/painting.dart';
import 'package:sketcher/converter/importer.dart';
import 'package:sketcher/models/stroke.dart';
import 'package:sketcher/sketcher.dart';
import 'package:xml/xml.dart';

class SvgImporter implements Importer {
  @override
  void import(SketchController controller, String svg) {
    final document = XmlDocument.parse(svg);
    final strokes = <Stroke>[];
    for (var pathNode in document.rootElement.children) {
      final d = pathNode.getAttribute("d");
      final stroke = pathNode.getAttribute("stroke");
      final strokeOpacity = double.parse(pathNode.getAttribute("stroke-opacity"));
      final strokeWidth = double.parse(pathNode.getAttribute("stroke-width"));

      final commands = d.split(" ");
      final points = <Offset>[];
      for (var i = 0; i < commands.length; i += 2) {
        final first = commands[i];
        final second = commands[i + 1];
        final dx = int.parse(first.substring(1));
        final dy = int.parse(second);
        points.add(Offset(dx.toDouble(), dy.toDouble()));
      }

      final strokeColor = _svgColorToFlutterColor(stroke).withOpacity(strokeOpacity);
      strokes.add(Stroke(points, strokeColor, strokeWidth));
    }
    controller.init(strokes);
  }

  Color _svgColorToFlutterColor(String code) {
    return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }
}
