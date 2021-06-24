// import 'package:flutter/painting.dart';
// import 'package:flutter/widgets.dart';
// import 'package:sketcher/src/tools/tool_controller.dart';
// import 'package:sketcher/src/ui/operations/stroke_operation.dart';
// import 'package:sketcher/src/ui/reactive_painter.dart';
// import 'package:sketcher/src/ui/sketch_controller.dart';
//
// class DrawLineController implements ToolController {
//   final SketchController _sketchController;
//   final OnStateUpdated _onStateUpdated;
//
//   DrawLineController(this._sketchController, this._onStateUpdated);
//
//   @override
//   ReactivePainter? toolPainter;//reactivepainter me stroke le raha
//   //static painter me path bhi
//
//   int nCurrentLayerID = 0;
//   //stack me layers ja ri h
//   //we are not commiting because commit pe undo redo was happening
//
//   @override
//   void panStart(PointerDownEvent details) {
//     toolPainter =
//         ReactivePainter(strokeStyle: _sketchController.activeToolStyle);
//    // toolPainter!.startStroke(details.localPosition);
//    //  _onStateUpdated();
//
//     nCurrentLayerID = _sketchController.nextLayerId;
//   }
//
//   @override
//   void panUpdate(PointerMoveEvent details) {
//     // toolPainter =
//     //     ReactivePainter(strokeStyle: _sketchController.activeToolStyle);
//
//     //_onStateUpdated();
//     toolPainter!.clear();//on move stroke's previous stroke ko remove krna h
//     toolPainter!.startStroke(details.localPosition);//start
//     print("h1");
//     toolPainter!.appendStroke(details.localPosition);//2 places where stroke moves
//     toolPainter!.appendStroke(details.localPosition + const Offset(3, 3) );
//     print("h2");
//      final stroke = toolPainter!.endStroke();
//     // toolPainter = null;
//     _onStateUpdated();//paint is happening over here
//
//     print("h3");
// //    final operation = StrokeOperation(stroke, nCurrentLayerID);
// //    _sketchController.commitOperation(operation);
//     // operation.redo(_sketchController);
//     print("h4");
//     //toolPainter?.strokes.clear();
//     //toolPainter = null;
//
//   }
//
//   @override
//   void panEnd(PointerUpEvent details) {
//     // final stroke = toolPainter!.endStroke();
//     toolPainter!.clear();//pen down pe clear ho spotlight
//     _onStateUpdated();
//      toolPainter = null;
//     // final operation = StrokeOperation(stroke, _sketchController.nextLayerId);
//     // _sketchController.commitOperation(operation);
//      }
//
//
//
//   @override
//   void panReset() {
//   //   toolPainter?.strokes.clear();
//   //   toolPainter = null;
//    }
// }

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
  IconPainter? toolPainter;//reactivepainter me stroke le raha
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
 toolPainter=IconPainter();
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

