import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:sketcher/src/models/curve.dart';
import 'package:sketcher/src/tools/tool_controller.dart';
import 'package:sketcher/src/ui/operations/resetall_operation.dart';
import 'package:sketcher/src/ui/reactive_painter.dart';
import 'package:sketcher/src/ui/sketch_controller.dart';
import 'package:sketcher/src/ui/sketch_layer.dart';
import 'package:sketcher/src/ui/operations/eraser_operation.dart';

class ResetAllController implements ToolController  {
  final SketchController _sketchController;
  final OnStateUpdated _onStateUpdated;
  
  ReactivePainter? toolPainter;
  
   ResetAllController(this._sketchController, this._onStateUpdated);

  @override
  void panStart(PointerDownEvent details) {
     }

  @override
  void panUpdate(PointerMoveEvent details) {     
  }
 
  @override
  void panEnd(PointerUpEvent details) {   
  }
 

  @override
  void panReset() {
    toolPainter = null;
  }
}

