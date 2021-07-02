import 'dart:ui';

import 'package:flutter/material.dart' as material;
import 'package:sketcher/src/models/curve.dart';
import 'package:sketcher/src/models/sketch_tool.dart';
import 'package:sketcher/src/models/stroke_style.dart';
import 'package:sketcher/src/ui/operations/eraser_operation.dart';
import 'package:sketcher/src/ui/operations/operation.dart';
import 'package:sketcher/src/ui/operations/resetall_operation.dart';
import 'package:sketcher/src/ui/sketch.dart';
import 'package:sketcher/src/ui/sketch_layer.dart';
import 'package:sketcher/src/ui/static_painter.dart';

/// Controls a [Sketch] widget
///
/// A [SketchController] creates undo and redo operations queue.
class SketchController extends material.ChangeNotifier {
  final _layers = <SketchLayer>[];
  final _undoStack = <Operation>[];
  final _redoStack = <Operation>[];
  SketchTool _activeTool = SketchTool.none;
  StrokeStyle _pencilStyle;
  StrokeStyle _highlighterStyle;
  int _lastLayerId = 0;
  Color _backgroundColor = material.Colors.transparent;

  List<SketchLayer> get layers => _layers;

  SketchController({
    StrokeStyle? pencilStyle,
    StrokeStyle? highlighterStyle,
  })  : _pencilStyle =
            pencilStyle ?? const StrokeStyle(1, material.Colors.black, 2),
        _highlighterStyle = highlighterStyle ??
            const StrokeStyle(0.3, material.Colors.black, 18);

  int get nextLayerId => ++_lastLayerId;

  Color get backgroundColor => _backgroundColor;

  SketchTool get activeTool => _activeTool;

  StrokeStyle get pencilConfig => _pencilStyle;

  StrokeStyle get highlightConfig => _highlighterStyle;

  bool get isRedoAvailable => _redoStack.isNotEmpty;

  bool get isUndoAvailable => _undoStack.isNotEmpty;

  void setActiveTool(SketchTool tool) {
    _activeTool = tool;
    notifyListeners();
  }

  void undo() {
    final operation = _undoStack.removeLast();
    _redoStack.add(operation);
    operation.undo(this);
    //   if (reactivePainter.strokes.isEmpty) {
    //     final staticPainter = staticPainters.removeLast();
    //     final kanjiStokes = staticPainter.strokes;
    //     _redoQueue.add(kanjiStokes.removeLast());
    //     reactivePainter.strokes.addAll(kanjiStokes);
    //   } else {
    //     _redoQueue.add(reactivePainter.strokes.removeLast());
    //   }
    //   notifyListeners();
  }

  void redo() {
    final operation = _redoStack.removeLast();
    _undoStack.add(operation);
    operation.redo(this);
    //   if (_redoQueue.isNotEmpty) {
    //     reactivePainter.strokes.add(_redoQueue.removeLast());
    //     notifyListeners();
    //   }
  }

  void setActiveColor(Color color) {
    activeToolStyle = activeToolStyle?.copy(color: color);
  }

  void setActiveWeight(double weight) {
    activeToolStyle = activeToolStyle?.copy(weight: weight);
  }

  void setActiveOpacity(double opacity) {
    activeToolStyle = activeToolStyle?.copy(opacity: opacity);
  }

  // ignore: missing_return
  StrokeStyle? get activeToolStyle {
    switch (_activeTool) {
      case SketchTool.none:
      case SketchTool.eraser:
        return null;
      case SketchTool.pencil:
        return _pencilStyle;
      case SketchTool.highlighter:
        return _highlighterStyle;
    }
  }

  set activeToolStyle(StrokeStyle? config) {
    switch (_activeTool) {
      case SketchTool.none:
      case SketchTool.eraser:
        break;
      case SketchTool.pencil:
        _pencilStyle = config!;
        break;
      case SketchTool.highlighter:
        _highlighterStyle = config!;
        break;
    }
    notifyListeners();
  }

  void notify() {
    notifyListeners();
  }

  // bool commitStrokes() {
  //   _redoQueue.clear();
  //   if (reactivePainter.strokes.isNotEmpty) {
  //     staticPainters.add(StaticPainter(List.of(reactivePainter.strokes)));
  //     reactivePainter.strokes.clear();
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }

  void init(List<Curve> curves, Color backgroundColor) {
    _backgroundColor = backgroundColor;
    final layer = SketchLayer(nextLayerId, StaticPainter(curves));
    layers.add(layer);
    notifyListeners();
  }

  void commitOperation(Operation operation) {
    _undoStack.add(operation);
    _redoStack.clear();
    operation.redo(this);
  }

  void resetAllOperation() {

    //var operation;
    final layers =
    List<SketchLayer>.from(this.layers, growable: false);
    final aliveCurves = <Curve>[];
    final deletedCurves = <Curve>[];

    List<EraserOperation> eraselist = <EraserOperation>[];

    print("in _searchDelete");
    for (final layer in layers) {
      for (final curve in layer.painter.curves) {
        deletedCurves.add(curve);
      }
      if (deletedCurves.isNotEmpty) {
        print("deleted curves: $deletedCurves");
        final operation =
        EraserOperation(layer, aliveCurves, this.nextLayerId);

        eraselist.add(operation);
      }

    }

    ResetAllOperation resetOperation = ResetAllOperation(eraselist);
    this.commitOperation(resetOperation);

    notify();

  }
}
