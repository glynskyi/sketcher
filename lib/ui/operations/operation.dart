import 'package:sketcher/sketcher.dart';

abstract class Operation {
  void redo(SketchController controller);

  void undo(SketchController controller);
}
