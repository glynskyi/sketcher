enum SketchTool {
  none,
  pencil,
  highlighter,
  eraser,
}

extension SketchToolExtension on SketchTool {
  T map<T>({
    required T Function(SketchTool) none,
    required T Function(SketchTool) pencil,
    required T Function(SketchTool) highlighter,
    required T Function(SketchTool) eraser,
  }) {
    switch (this) {
      case SketchTool.none:
        return none(this);
      case SketchTool.pencil:
        return pencil(this);
      case SketchTool.highlighter:
        return highlighter(this);
      case SketchTool.eraser:
        return eraser(this);
      default:
        throw ArgumentError.value(this, "map");
    }
  }

  bool get hasColorSelector => map(
        none: (_) => false,
        pencil: (_) => true,
        highlighter: (_) => true,
        eraser: (_) => false,
      );

  bool get hasSizeSelector => map(
        none: (_) => false,
        pencil: (_) => true,
        highlighter: (_) => true,
        eraser: (_) => false,
      );
}
