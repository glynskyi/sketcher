import 'package:sketcher/sketcher.dart';

abstract class Importer {
  void import(SketchController controller, String source);
}
