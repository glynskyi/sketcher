import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sketcher/src/models/sketch_tool.dart';
import 'package:sketcher/src/tools/eraser_controller.dart';
import 'package:sketcher/src/tools/pencil_controller.dart';
import 'package:sketcher/src/tools/tool_controller.dart';
import 'package:sketcher/src/ui/gesture_action.dart';
import 'package:sketcher/src/ui/sketch_controller.dart';

/// A widget that provides a canvas on which a user makes handwriting.
class Sketch extends StatefulWidget {
  final SketchController controller;
  final ScrollController scrollController;

  const Sketch({
    Key? key,
    required this.controller,
    required this.scrollController,
  }) : super(key: key);

  @override
  _SketchState createState() => _SketchState();
}

class _SketchState extends State<Sketch> {
  Widget? touch;
  SketchTool _activeTool = SketchTool.None;
  ToolController? _toolController;

  double _offset = 0;
  GestureAction? _gestureAction;
  PointerDownEvent? _gesturePointerDownEvent;
  double? _initialScroll;

  void panStart(PointerDownEvent details) {
    if (_gestureAction == null) {
      _gestureAction = GestureAction.Drawing;
      _gesturePointerDownEvent = details;
      if (_activeTool == SketchTool.Pencil || _activeTool == SketchTool.Highlighter) {
        _toolController = PencilController(widget.controller, () => widget.controller.notify());
      }
      if (_activeTool == SketchTool.Eraser) {
        _toolController = EraserController(widget.controller, () => widget.controller.notify());
      }
      _toolController!.panStart(details);
    } else if (_gestureAction == GestureAction.Drawing && _isCloserToInitialGesture(details)) {
      _gestureAction = GestureAction.Scrolling;
      _initialScroll = widget.scrollController.offset;
      _toolController!.panReset();
      _toolController = null;
    }
  }

  bool _isCloserToInitialGesture(PointerDownEvent details) {
    return (details.timeStamp - _gesturePointerDownEvent!.timeStamp).inMilliseconds < 400;
  }

  void panUpdate(PointerMoveEvent details) {
    if (_gestureAction == GestureAction.Drawing) {
      if (_gesturePointerDownEvent!.pointer != details.pointer) {
        return;
      }
      _toolController?.panUpdate(details);
    } else if (_gestureAction == GestureAction.Scrolling) {
      if (_gesturePointerDownEvent?.pointer == details.pointer) {
        final offset = _gesturePointerDownEvent!.position - details.position;
        widget.scrollController.jumpTo(_initialScroll! + offset.dy / 2);
      }
    }
  }

  void panEnd(PointerUpEvent details) {
    if (_gesturePointerDownEvent?.pointer != details.pointer) {
      return;
    }
    _toolController?.panEnd(details);
    _toolController = null;
    _gestureAction = null;
    _gesturePointerDownEvent = null;
    _initialScroll = null;
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
    return Container(
      color: widget.controller.backgroundColor,
      child: Transform.translate(
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
      ),
    );
  }
}
