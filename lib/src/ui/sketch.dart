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
  late Widget touch;
  SketchTool _activeTool = SketchTool.none;
  ToolController? _toolController;

  double _offset = 0;
  GestureAction? _gestureAction;
  PointerDownEvent? _gesturePointerDownEvent;
  double? _initialScroll;

  T translate<T extends PointerEvent>(T originEvent) {
    return originEvent.transformed(
      originEvent.transform!.clone()..leftTranslate(0.0, _offset),
    ) as T;
  }

  void panStart(PointerDownEvent event) {
    final translatedEvent = translate(event);
    if (_gestureAction == null) {
      _gestureAction = GestureAction.drawing;
      _gesturePointerDownEvent = translatedEvent;
      if (_activeTool == SketchTool.pencil ||
          _activeTool == SketchTool.highlighter) {
        _toolController = PencilController(
          widget.controller,
          () => widget.controller.notify(),
        );
      }
      if (_activeTool == SketchTool.eraser) {
        _toolController = EraserController(
          widget.controller,
          () => widget.controller.notify(),
        );
      }
      _toolController!.panStart(translatedEvent);
    } else if (_gestureAction == GestureAction.drawing &&
        _isCloserToInitialGesture(translatedEvent)) {
      _gestureAction = GestureAction.scrolling;
      _initialScroll = widget.scrollController.offset;
      _toolController!.panReset();
      _toolController = null;
    }
  }

  bool _isCloserToInitialGesture(PointerDownEvent details) {
    return (details.timeStamp - _gesturePointerDownEvent!.timeStamp)
            .inMilliseconds <
        400;
  }

  void panUpdate(PointerMoveEvent event) {
    final translatedEvent = translate(event);
    if (_gestureAction == GestureAction.drawing) {
      if (_gesturePointerDownEvent!.pointer != translatedEvent.pointer) {
        return;
      }
      _toolController?.panUpdate(translatedEvent);
    } else if (_gestureAction == GestureAction.scrolling) {
      if (_gesturePointerDownEvent?.pointer == translatedEvent.pointer) {
        final offset =
            _gesturePointerDownEvent!.position - translatedEvent.position;
        widget.scrollController.jumpTo(_initialScroll! + offset.dy / 2);
      }
    }
  }

  void panEnd(PointerUpEvent event) {
    final translatedEvent = translate(event);
    if (_gesturePointerDownEvent?.pointer != translatedEvent.pointer) {
      return;
    }
    _toolController?.panEnd(translatedEvent);
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
    return IgnorePointer(
      ignoring: _activeTool == SketchTool.none,
      child: Container(
        color: widget.controller.backgroundColor,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Transform.translate(
              offset: Offset(0, -_offset),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ...RepaintBoundary.wrapAll(
                    widget.controller.layers
                        .map(
                          (layer) => CustomPaint(
                            key: ValueKey(layer.id),
                            painter: layer.painter,
                          ),
                        )
                        .toList(growable: false),
                  ),
                  CustomPaint(
                    painter: _toolController?.toolPainter,
                  ),
                ],
              ),
            ),
            touch,
          ],
        ),
      ),
    );
  }
}
