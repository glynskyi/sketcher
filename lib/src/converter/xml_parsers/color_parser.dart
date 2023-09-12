import 'dart:ui';

import 'package:sketcher/src/converter/xml_parsers/number_parser.dart';

/// Converts a SVG Color String (either a # prefixed color string or a named color) to a [Color].
Color? parseColor(String? colorString) {
  if (colorString == null || colorString.isEmpty) {
    return null;
  }

  if (colorString == 'none') {
    return null;
  }

  // handle hex colors e.g. #fff or #ffffff.  This supports #RRGGBBAA
  if (colorString[0] == '#') {
    if (colorString.length == 4) {
      final String r = colorString[1];
      final String g = colorString[2];
      final String b = colorString[3];
      colorString = '#$r$r$g$g$b$b';
    }
    int color = int.parse(colorString.substring(1), radix: 16);

    if (colorString.length == 7) {
      return Color(color |= 0xFF000000);
    }

    if (colorString.length == 9) {
      return Color(color);
    }
  }

  // handle rgba() colors e.g. rgba(255, 255, 255, 1.0)
  if (colorString.toLowerCase().startsWith('rgba')) {
    final List<String> rawColorElements = colorString
        .substring(colorString.indexOf('(') + 1, colorString.indexOf(')'))
        .split(',')
        .map((String rawColor) => rawColor.trim())
        .toList();

    final double opacity = parseDouble(rawColorElements.removeLast())!;

    final List<int> rgb = rawColorElements.map((String rawColor) => int.parse(rawColor)).toList();

    return Color.fromRGBO(rgb[0], rgb[1], rgb[2], opacity);
  }

  // Conversion code from: https://github.com/MichaelFenwick/Color, thanks :)
  if (colorString.toLowerCase().startsWith('hsl')) {
    final List<int> values =
        colorString.substring(colorString.indexOf('(') + 1, colorString.indexOf(')')).split(',').map((String rawColor) {
      rawColor = rawColor.trim();

      if (rawColor.endsWith('%')) {
        rawColor = rawColor.substring(0, rawColor.length - 1);
      }

      if (rawColor.contains('.')) {
        return (parseDouble(rawColor)! * 2.55).round();
      }

      return int.parse(rawColor);
    }).toList();
    final double hue = values[0] / 360 % 1;
    final double saturation = values[1] / 100;
    final double luminance = values[2] / 100;
    final int alpha = values.length > 3 ? values[3] : 255;
    List<double> rgb = <double>[0, 0, 0];

    if (hue < 1 / 6) {
      rgb[0] = 1;
      rgb[1] = hue * 6;
    } else if (hue < 2 / 6) {
      rgb[0] = 2 - hue * 6;
      rgb[1] = 1;
    } else if (hue < 3 / 6) {
      rgb[1] = 1;
      rgb[2] = hue * 6 - 2;
    } else if (hue < 4 / 6) {
      rgb[1] = 4 - hue * 6;
      rgb[2] = 1;
    } else if (hue < 5 / 6) {
      rgb[0] = hue * 6 - 4;
      rgb[2] = 1;
    } else {
      rgb[0] = 1;
      rgb[2] = 6 - hue * 6;
    }

    rgb = rgb.map((double val) => val + (1 - saturation) * (0.5 - val)).toList();

    if (luminance < 0.5) {
      rgb = rgb.map((double val) => luminance * 2 * val).toList();
    } else {
      rgb = rgb.map((double val) => luminance * 2 * (1 - val) + 2 * val - 1).toList();
    }

    rgb = rgb.map((double val) => val * 255).toList();

    return Color.fromARGB(alpha, rgb[0].round(), rgb[1].round(), rgb[2].round());
  }

  // handle rgb() colors e.g. rgb(255, 255, 255)
  if (colorString.toLowerCase().startsWith('rgb')) {
    final List<int> rgb =
        colorString.substring(colorString.indexOf('(') + 1, colorString.indexOf(')')).split(',').map((String rawColor) {
      rawColor = rawColor.trim();
      if (rawColor.endsWith('%')) {
        rawColor = rawColor.substring(0, rawColor.length - 1);
        return (parseDouble(rawColor)! * 2.55).round();
      }
      return int.parse(rawColor);
    }).toList();

    // rgba() isn't really in the spec, but Firefox supported it at one point so why not.
    final int a = rgb.length > 3 ? rgb[3] : 255;
    return Color.fromARGB(a, rgb[0], rgb[1], rgb[2]);
  }

  throw StateError('Could not parse "$colorString" as a color.');
}
