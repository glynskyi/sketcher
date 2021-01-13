import 'package:sketcher/src/ui/sketch_controller.dart';

abstract class Importer {
  void import(SketchController controller, String source);
}
