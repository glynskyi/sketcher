//import 'dart:ui';
import 'package:sketcher/src/ui/operations/eraser_operation.dart';
import 'package:sketcher/src/ui/operations/operation.dart';
import 'package:sketcher/src/ui/sketch_controller.dart';

class ResetAllOperation implements Operation {

  List <EraserOperation> eraselist;

  ResetAllOperation(this.eraselist);

  @override
  void redo(SketchController controller) {
    for(final operation in eraselist) {
      operation.redo(controller);
    }
  }

  @override
  void undo(SketchController controller) {
    for(final operation in eraselist) {
      operation.undo(controller);
    }
  }

}

