enum SketchTool {
  none,
  pencil,
  highlighter,
  eraser,
  spotlight,
   //resetall
}

extension SketchToolExtension on SketchTool {
  T map<T>({
    required T Function(SketchTool) none,
    required T Function(SketchTool) pencil,
    required T Function(SketchTool) highlighter,
    required T Function(SketchTool) eraser,
    required T Function(SketchTool) spotlight,
    //required T Function(SketchTool) resetall
  }) {
    switch (this) {
      case SketchTool.none:
        return none(this);
      case SketchTool.pencil:
        return pencil(this);
      case SketchTool.highlighter:
        return highlighter(this);
        case SketchTool.spotlight:
      return spotlight(this);
      case SketchTool.eraser:
        return eraser(this);
      //case SketchTool.resetall:
        //return resetall(this);
      default:
        throw ArgumentError.value(this, "map");
    }
  }

  bool get hasColorSelector => map(
        none: (_) => false,
        pencil: (_) => true,
        highlighter: (_) => true,
        eraser: (_) => false,
        //resetall: (_) => false,
       spotlight: (_) => true,
      );

  bool get hasSizeSelector => map(
        none: (_) => false,
        pencil: (_) => true,
        highlighter: (_) => true,
        spotlight: (_) => true,
        eraser: (_) => false,
        //resetall: (_) => false,
      );
}
