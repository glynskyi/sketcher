import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sketcher/models/sketch_tool.dart';
import 'package:sketcher/tools/eraser_controller.dart';
import 'package:sketcher/tools/pencil_controller.dart';
import 'package:sketcher/tools/tool_controller.dart';
import 'package:sketcher/ui/sketch_controller.dart';

class Sketch extends StatefulWidget {
  final SketchController controller;
  final ScrollController scrollController;

  const Sketch({
    Key key,
    @required this.controller,
    @required this.scrollController,
  }) : super(key: key);

  @override
  _SketchState createState() => _SketchState();
}

class _SketchState extends State<Sketch> {
  Widget touch;
  SketchTool _activeTool = SketchTool.None;
  ToolController _toolController;

  double _offset = 0;
  int initialPointer;

  void panStart(PointerDownEvent details) {
    initialPointer = details.pointer;
    if (_activeTool == SketchTool.Pencil || _activeTool == SketchTool.Highlighter) {
      _toolController = PencilController(widget.controller, () => widget.controller.notify());
      _toolController.panStart(details);
    }
    if (_activeTool == SketchTool.Eraser) {
      _toolController = EraserController(widget.controller, () => widget.controller.notify());
      _toolController?.panStart(details);
    }
  }

  void panUpdate(PointerMoveEvent details) {
    if (initialPointer != details.pointer) {
      return;
    }
//    if (details.kind != PointerDeviceKind.stylus) return;
//    print(details.globalPosition);
    _toolController?.panUpdate(details);
  }

  void panEnd(PointerUpEvent details) {
    if (initialPointer != details.pointer) {
      return;
    }
//    if (details.kind != PointerDeviceKind.stylus) return;
    _toolController?.panEnd(details);
    _toolController = null;
  }

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_handleControllerChange);
    widget.scrollController.addListener(_handleScrollChange);
    touch = Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: panStart,
      onPointerMove: panUpdate,
      onPointerUp: panEnd,
    );
  }

  @override
  void dispose() {
    super.dispose();
    widget.controller.removeListener(_handleControllerChange);
    widget.scrollController.removeListener(_handleScrollChange);
  }

  void _handleControllerChange() {
    print("_handleControllerChange()");
    setState(() {
      _activeTool = widget.controller.activeTool;
      final config = widget.controller.activeToolStyle;
      if (config != null) {
        // widget.controller.reactivePainter.activeWeight = config.weight;
        // widget.controller.reactivePainter.activeColor = config.color.withOpacity(config.opacity);
      }
    });
  }

  void _handleScrollChange() {
    setState(() {
      _offset = widget.scrollController.offset;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0, -_offset),
      child: Stack(
        children: [
          ...RepaintBoundary.wrapAll(widget.controller.layers
              .map((layer) => CustomPaint(key: ValueKey(layer.id), painter: layer.painter))
              .toList(growable: false)),
          CustomPaint(
            painter: _toolController?.toolPainter,
            child: _activeTool == SketchTool.None ? null : touch,
          ),
        ],
      ),
    );
  }
}
