import 'package:flutter/material.dart';
import 'package:sketcher/sketcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _sketchController = SketchController();
  final _scrollController = ScrollController();

  void _selectColor(Color color) {
    _sketchController.setActiveColor(color);
  }

  @override
  void initState() {
    super.initState();
    print("initState()");
    _sketchController.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.undo),
            onPressed: _sketchController.isUndoAvailable
                ? () => _sketchController.undo()
                : null,
          ),
          IconButton(
            icon: const Icon(Icons.redo),
            onPressed: _sketchController.isRedoAvailable
                ? () => _sketchController.redo()
                : null,
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          _buildSketch(),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text("Sketch your ideas to life"),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildBottomBar(),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Material(
      elevation: 10,
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.palette, color: Colors.redAccent),
            onPressed: () => _selectColor(Colors.redAccent),
          ),
          IconButton(
            icon: const Icon(Icons.palette, color: Colors.lightGreenAccent),
            onPressed: () => _selectColor(Colors.lightGreenAccent),
          ),
          IconButton(
            icon: const Icon(Icons.palette, color: Colors.black),
            onPressed: () => _selectColor(Colors.black),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.approval),
            onPressed: () => _sketchController.setActiveTool(SketchTool.Eraser),
          ),
          IconButton(
            icon: const Icon(Icons.highlight),
            onPressed: () =>
                _sketchController.setActiveTool(SketchTool.Highlighter),
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _sketchController.setActiveTool(SketchTool.Pencil),
          ),
        ],
      ),
    );
  }

  Widget _buildSketch() {
    return Sketch(
      controller: _sketchController,
      scrollController: _scrollController,
    );
  }
}
