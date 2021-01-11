import 'package:flutter/material.dart';
import 'package:sketcher/models/sketch_tool.dart';
import 'package:sketcher/models/stroke.dart';
import 'package:sketcher/models/stroke_style.dart';
import 'package:sketcher/ui/reactive_painter.dart';
import 'package:sketcher/ui/static_painter.dart';

class SketchController extends ChangeNotifier {
  SketchTool _activeTool;
  StrokeStyle _pencilStyle;
  StrokeStyle _highlighterStyle;
  final _redoQueue = <Stroke>[];
  ReactivePainter reactivePainter = ReactivePainter(const Color.fromRGBO(255, 255, 255, 1.0));
  List<StaticPainter> staticPainters = [];

  SketchController({
    StrokeStyle pencilStyle,
    StrokeStyle highlighterStyle,
  }) {
    _pencilStyle = pencilStyle ?? StrokeStyle(1, Colors.black, 2);
    _highlighterStyle = highlighterStyle ?? StrokeStyle(0.3, Colors.black, 18);
  }

  SketchTool get activeTool => _activeTool;

  StrokeStyle get pencilConfig => _pencilStyle;

  StrokeStyle get highlightConfig => _highlighterStyle;

  bool get isRedoAvailable => _redoQueue.isNotEmpty;

  bool get isUndoAvailable {
    return staticPainters.any((painter) => painter.strokes.isNotEmpty) || reactivePainter.strokes.isNotEmpty;
  }

  void setActiveTool(SketchTool tool) {
    _activeTool = tool;
    notifyListeners();
  }

  void undo() {
    if (reactivePainter.strokes.isEmpty) {
      final staticPainter = staticPainters.removeLast();
      final kanjiStokes = staticPainter.strokes;
      _redoQueue.add(kanjiStokes.removeLast());
      reactivePainter.strokes.addAll(kanjiStokes);
    } else {
      _redoQueue.add(reactivePainter.strokes.removeLast());
    }
    notifyListeners();
  }

  void redo() {
    if (_redoQueue.isNotEmpty) {
      reactivePainter.strokes.add(_redoQueue.removeLast());
      notifyListeners();
    }
  }

  void setActiveColor(Color color) {
    activeToolStyle = activeToolStyle?.copy(color: color);
  }

  void setActiveWeight(double weight) {
    activeToolStyle = activeToolStyle?.copy(weight: weight);
  }

  // ignore: missing_return
  StrokeStyle get activeToolStyle {
    switch (_activeTool) {
      case SketchTool.None:
      case SketchTool.Eraser:
        return null;
      case SketchTool.Pencil:
        return _pencilStyle;
      case SketchTool.Highlighter:
        return _highlighterStyle;
    }
  }

  set activeToolStyle(StrokeStyle config) {
    switch (_activeTool) {
      case SketchTool.None:
      case SketchTool.Eraser:
        break;
      case SketchTool.Pencil:
        _pencilStyle = config;
        break;
      case SketchTool.Highlighter:
        _highlighterStyle = config;
        break;
    }
    notifyListeners();
  }

  void notify() {
    return notifyListeners();
  }

  bool commitStrokes() {
    _redoQueue.clear();
    if (reactivePainter.strokes.isNotEmpty) {
      staticPainters.add(StaticPainter(List.of(reactivePainter.strokes)));
      reactivePainter.strokes.clear();
      return true;
    } else {
      return false;
    }
  }

  void init(StaticPainter staticPainter) {
    staticPainters.add(staticPainter);
    notifyListeners();
  }
}
