import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:sketcher/src/tools/tool_controller.dart';
import 'package:sketcher/src/ui/icon_painter.dart';
import 'package:sketcher/src/ui/sketch_controller.dart';

class DrawLineController implements ToolController {
  final SketchController _sketchController;
  final OnStateUpdated _onStateUpdated;

  DrawLineController(this._sketchController, this._onStateUpdated);

  @override
  IconPainter? toolPainter;

  int nCurrentLayerID = 0;
  
  @override
  void panStart(PointerDownEvent details) {
    // toolPainter=IconPainter();
  }

  @override
  void panUpdate(PointerMoveEvent details) {
 toolPainter=IconPainter();error: src refspec master does not match any
error: failed to push some refs to 'https://github.com/Divyawhitetree/sketcher.git'
 toolPainter!.offset=details.localPosition;
 toolPainter !.radius=10;
  _onStateUpdated();


  }

  @override
  void panEnd(PointerUpEvent details) {

    toolPainter=null;
    _onStateUpdated();
  }



  @override
  void panReset() {
    //   toolPainter?.strokes.clear();
    //   toolPainter = null;
  }
}

