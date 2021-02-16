enum SketchTool {
  None,
  Pencil,
  Highlighter,
  Eraser,
}

extension SketchToolExtension on SketchTool {
  T map<T>({
    required T Function(SketchTool) none,
    required T Function(SketchTool) pencil,
    required T Function(SketchTool) highlighter,
    required T Function(SketchTool) eraser,
  }) {
    switch (this) {
      case SketchTool.None:
        return none(this);
      case SketchTool.Pencil:
        return pencil(this);
      case SketchTool.Highlighter:
        return highlighter(this);
      case SketchTool.Eraser:
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
