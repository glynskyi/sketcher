import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:sketcher/src/tools/tool_controller.dart';

import 'package:sketcher/src/ui/icon_painter.dart';

import 'package:sketcher/src/ui/sketch_controller.dart';

class SpotLightController implements ToolController {
  final SketchController _sketchController;
  final OnStateUpdated _onStateUpdated;
  SpotLightController(this._sketchController, this._onStateUpdated) {}

  @override
  IconPainter? toolPainter; //reactivepainter me stroke le raha
  //static painter me path bhi


  int nCurrentLayerID = 0;
  //stack me layers ja ri h
  //we are not commiting because commit pe undo redo was happening

  @override
  void panStart(PointerDownEvent details) {
    // toolPainter=IconPainter();
  }

  @override
  void panUpdate(PointerMoveEvent details) {
    toolPainter = IconPainter();

    toolPainter!.radius = 10;
    toolPainter!.offset = details.localPosition;

    _onStateUpdated();
  }

  @override
  void panEnd(PointerUpEvent details) {
    toolPainter = null;
    _onStateUpdated();
  }

  @override
  void panReset() {
    //   toolPainter?.strokes.clear();
    //   toolPainter = null;
  }
}
