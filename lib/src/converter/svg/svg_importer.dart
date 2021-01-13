import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:sketcher/src/converter/importer.dart';
import 'package:sketcher/src/models/stroke.dart';
import 'package:sketcher/src/ui/sketch_controller.dart';
import 'package:xml/xml.dart';

/// A utility class for decoding SVG data to a [SketchController]
class SvgImporter implements Importer {
  @override
  void import(SketchController controller, String svg) {
    final document = XmlDocument.parse(svg);
    final strokes = <Stroke>[];
    for (var pathNode in document.rootElement.children) {
      final d = pathNode.getAttribute("d");
      final stroke = pathNode.getAttribute("stroke");
      final strokeOpacity =
          double.parse(pathNode.getAttribute("stroke-opacity"));
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

      final strokeColor =
          _svgColorToFlutterColor(stroke).withOpacity(strokeOpacity);
      strokes.add(Stroke(points, strokeColor, strokeWidth));
    }
    final viewportFill = document.rootElement.getAttribute("viewport-fill");
    final backgroundColor = viewportFill != null
        ? _svgColorToFlutterColor(viewportFill)
        : Colors.lightGreenAccent;
    controller.init(strokes, backgroundColor);
  }

  Color _svgColorToFlutterColor(String code) {
    return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }
}
