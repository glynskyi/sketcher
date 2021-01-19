import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sketcher/sketcher.dart';
import 'package:sketcher/src/converter/svg/svg_exporter.dart';
import 'package:sketcher/src/converter/svg/svg_importer.dart';
import 'package:sketcher/src/models/stroke.dart';
import 'package:sketcher/src/tools/eraser_controller.dart';
import 'package:sketcher/src/tools/pencil_controller.dart';
import 'package:sketcher/src/ui/operations/stroke_operation.dart';

void main() {
  group('PencilController', () {
    test('should not provide a tool painter by default', () {
      final sketchController = SketchController();
      sketchController.setActiveTool(SketchTool.Pencil);
      final pencil = PencilController(sketchController, () {});
      expect(pencil.toolPainter, isNull);
    });

    test('should provide a tool painter after activation', () {
      final sketchController = SketchController();
      sketchController.setActiveTool(SketchTool.Pencil);
      final pencil = PencilController(sketchController, () {});
      pencil.panStart(const PointerDownEvent());
      expect(pencil.toolPainter, isNotNull);
    });

    test('should add a stroke', () {
      final sketchController = SketchController();
      sketchController.setActiveTool(SketchTool.Pencil);
      final pencil = PencilController(sketchController, () {});
      pencil.panStart(const PointerDownEvent(position: Offset(0, 0)));
      pencil.panUpdate(const PointerMoveEvent(position: Offset(10, 0)));
      pencil.panEnd(const PointerUpEvent());
      expect(sketchController.layers, hasLength(1));
      expect(sketchController.layers.first.painter.strokes, hasLength(1));
    });
  });

  group('EraserController', () {
    test('should not provide a tool painter by default', () {
      final sketchController = SketchController();
      sketchController.setActiveTool(SketchTool.Eraser);
      final eraser = EraserController(sketchController, () {});
      expect(eraser.toolPainter, isNull);
    });

    test('should not provide a tool painter after activation', () {
      final sketchController = SketchController();
      sketchController.setActiveTool(SketchTool.Eraser);
      final eraser = EraserController(sketchController, () {});
      eraser.panStart(const PointerDownEvent());
      expect(eraser.toolPainter, isNull);
    });

    test('should remove a stroke', () {
      final sketchController = SketchController();
      const stroke = Stroke([Offset(0, 0), Offset(10, 10)], Colors.red, 1);
      sketchController.commitOperation(
          StrokeOperation(stroke, sketchController.nextLayerId));
      sketchController.setActiveTool(SketchTool.Eraser);
      final eraser = EraserController(sketchController, () {});
      eraser.panStart(const PointerDownEvent(position: Offset(0, 0)));
      eraser.panUpdate(const PointerMoveEvent(position: Offset(10, 0)));
      eraser.panEnd(const PointerUpEvent());
      expect(sketchController.layers, hasLength(1));
      expect(sketchController.layers.first.painter.strokes, isEmpty);
    });
  });

  group('StrokeOperation', () {
    test('should add a stroke', () {
      final sketchController = SketchController();
      const stroke = Stroke([Offset(0, 0), Offset(10, 0)], Colors.red, 1.0);
      final operation = StrokeOperation(stroke, sketchController.nextLayerId);
      sketchController.commitOperation(operation);
      expect(sketchController.layers, hasLength(1));
      expect(sketchController.layers.first.painter.strokes, hasLength(1));
    });

    test('should undo the add operation', () {
      final sketchController = SketchController();
      const stroke = Stroke([Offset(0, 0), Offset(10, 0)], Colors.red, 1.0);
      final operation = StrokeOperation(stroke, sketchController.nextLayerId);
      sketchController.commitOperation(operation);
      sketchController.undo();
      expect(sketchController.layers, isEmpty);
    });
  });

  group('SvgExporter', () {
    test('should export strokes', () {
      final sketchController = SketchController();
      const stroke =
          Stroke([Offset(0, 0), Offset(10, 0)], Color(0xFFFF0000), 1.0);
      final operation = StrokeOperation(stroke, sketchController.nextLayerId);
      sketchController.commitOperation(operation);
      final exporter = SvgExporter();
      final svg = exporter.export(sketchController);
      expect(svg, contains("M0 0 L10 0"));
      expect(svg, contains("#FF0000"));
    });

    test('should export background color', () {
      final sketchController = SketchController();
      sketchController.init([], const Color(0xFF00FF00));
      const stroke =
          Stroke([Offset(0, 0), Offset(10, 0)], Color(0xFFFF0000), 1.0);
      final operation = StrokeOperation(stroke, sketchController.nextLayerId);
      sketchController.commitOperation(operation);
      final exporter = SvgExporter();
      final svg = exporter.export(sketchController);
      expect(svg, contains("viewport-fill=\"#00FF00\""));
    });
  });

  group('SvgImporter', () {
    test('should import strokes', () {
      final sketchController = SketchController();
      final importer = SvgImporter();
      importer.import(sketchController,
          '<?xml version="1.0"?><svg viewport-fill="#00FF00"><path d="M0 0 L10 0" stroke="#FF0000" stroke-opacity="1.0" stroke-width="1" fill="none"/></svg>');
      expect(sketchController.layers, hasLength(1));
      expect(sketchController.layers.first.painter.strokes, hasLength(1));
      final stroke = sketchController.layers.first.painter.strokes.first;
      expect(stroke.color, const Color(0xFFFF0000));
      expect(stroke.points, const [Offset(0, 0), Offset(10, 0)]);
      expect(stroke.weight, 1.0);
    });
    test('should import background color', () {
      final sketchController = SketchController();
      final importer = SvgImporter();
      importer.import(sketchController,
          '<?xml version="1.0"?><svg viewport-fill="#00FF00"><path d="M0 0 L10 0" stroke="#FF0000" stroke-opacity="1.0" stroke-width="1" fill="none"/></svg>');
      expect(sketchController.backgroundColor, const Color(0xFF00FF00));
    });
  });
}
