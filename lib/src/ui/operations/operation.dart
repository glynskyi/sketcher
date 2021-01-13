import 'package:sketcher/src/ui/sketch_controller.dart';

abstract class Operation {
  void redo(SketchController controller);

  void undo(SketchController controller);
}
