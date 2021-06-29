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
  //List <EraserOperation> eraseoperation;
  //final int _tolerance = 10;
  // @override
  ReactivePainter? toolPainter;
  //
  // // ResetAllController(this._sketchController, this._onStateUpdated, this.eraseoperation);
   ResetAllController(this._sketchController, this._onStateUpdated);

  @override
  void panStart(PointerDownEvent details) {
    // // toolPainter = ReactivePainter(_sketchController.activeToolStyle);
    // // if (_sketchController.commitStrokes()) {
    // //   _onStateUpdated();
    // // }
    // _searchDeleteStroke(details.localPosition);
    // _onStateUpdated();
    // //_onStateUpdated();
  }

  @override
  void panUpdate(PointerMoveEvent details) {
         // _searchDeleteStroke(details.localPosition);
  }
  // (DragUpdateDetails details) {


  @override
  void panEnd(PointerUpEvent details) {
   // _onStateUpdated();
   //  _searchDeleteStroke(details.localPosition);
  }

  // void _searchDeleteStroke(Offset offset) {
  //
  //   //var operation;
  //   final layers =
  //       List<SketchLayer>.from(_sketchController.layers, growable: false);
  //   final aliveCurves = <Curve>[];
  //   final deletedCurves = <Curve>[];
  //
  //   List<EraserOperation> eraselist = <EraserOperation>[];
  //
  //   print("in _searchDelete");
  //   for (final layer in layers) {
  //     for (final curve in layer.painter.curves) {
  //       deletedCurves.add(curve);
  //     }
  //     if (deletedCurves.isNotEmpty) {
  //       print("deleted curves: $deletedCurves");
  //       final operation =
  //           EraserOperation(layer, aliveCurves, _sketchController.nextLayerId);
  //
  //       eraselist.add(operation);
  //     }
  //
  //   }
  //
  //   // ResetAllController reset =new ResetAllController();
  //   // reset.resetalloperation[0] = new ResetAllOperation();
  //   // print(reset.resetalloperation[0].eraselist.length);
  //   // listEvents = [operation];
  //   ResetAllOperation resetOperation = ResetAllOperation(eraselist);
  //   _sketchController.commitOperation(resetOperation);
  //
  // }

  @override
  void panReset() {

    toolPainter = null;
  }
}

