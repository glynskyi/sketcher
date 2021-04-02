import 'dart:ui';

import 'package:flutter/material.dart' as material;
import 'package:sketcher/src/converter/importer.dart';
import 'package:sketcher/src/models/curve.dart';
import 'package:sketcher/src/models/path_curve.dart';
import 'package:sketcher/src/models/stroke.dart';
import 'package:sketcher/src/ui/sketch_controller.dart';
import 'package:xml/xml.dart';

/// A utility class for decoding SVG data to a [SketchController]
class SvgImporter implements Importer {
  @override
  void import(SketchController controller, String svg) {
    final document = XmlDocument.parse(svg);
    final curves = <Curve>[];
    for (final pathNode in document.rootElement.children) {
      if (pathNode.nodeType == XmlNodeType.ELEMENT) {
        if (pathNode.getAttribute("id") == "cubiccurveABBC") {
          curves.add(_readPathCurve(pathNode));
        } else {
          curves.add(_readStroke(pathNode));
        }
      }
    }
    final viewportFill = document.rootElement.getAttribute("viewport-fill");
    final backgroundColor = viewportFill != null
        ? _svgColorToFlutterColor(viewportFill)
        : material.Colors.transparent;
    controller.init(curves, backgroundColor);
  }

  Curve _readPathCurve(XmlNode pathNode) {
    return PathCurve(pathNode);
  }

  Curve _readStroke(XmlNode pathNode) {
    final stroke = pathNode.getAttribute("stroke")!;
    final strokeOpacity =
        double.parse(pathNode.getAttribute("stroke-opacity")!);
    final strokeWidth = double.parse(pathNode.getAttribute("stroke-width")!);

    final d = pathNode.getAttribute("d")!;
    final commands = d.split(" ");
    final points = <Offset>[];
    for (var i = 0; i < commands.length; i += 2) {
      final first = commands[i];
      final second = commands[i + 1];
      final dx = double.parse(first.substring(1));
      final dy = double.parse(second);
      points.add(Offset(dx, dy));
    }

    final strokeColor =
        _svgColorToFlutterColor(stroke).withOpacity(strokeOpacity);
    return Stroke(points, strokeColor, strokeWidth);
  }

  Color _svgColorToFlutterColor(String code) {
    return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }
}
