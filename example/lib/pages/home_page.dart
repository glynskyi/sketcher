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

  void _selectPencil() {
    _sketchController.setActiveTool(SketchTool.Pencil);
  }

  void _selectHighlighter() {
    _sketchController.setActiveTool(SketchTool.Highlighter);
  }

  void _selectColor(Color color) {
    _sketchController.setActiveColor(color);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.undo),
            onPressed: _sketchController.isUndoAvailable ? () => _sketchController.undo() : null,
          ),
          IconButton(
            icon: const Icon(Icons.redo),
            onPressed: _sketchController.isRedoAvailable ? () => _sketchController.redo() : null,
          ),
        ],
      ),
      body: Stack(
        children: [
          Expanded(child: _buildSketch()),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text("Sketch your ideas to life"),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const SizedBox(width: 32),
          FloatingActionButton(
            onPressed: () => _selectColor(Colors.redAccent),
            tooltip: "Red",
            backgroundColor: Colors.redAccent,
            child: const Icon(Icons.palette),
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
            onPressed: () => _selectColor(Colors.lightGreenAccent),
            tooltip: "Green",
            backgroundColor: Colors.lightGreenAccent,
            child: const Icon(Icons.palette),
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
            onPressed: () => _selectColor(Colors.black),
            tooltip: "Black",
            backgroundColor: Colors.black87,
            child: const Icon(Icons.palette),
          ),
          const Spacer(),
          FloatingActionButton(
            onPressed: _selectHighlighter,
            tooltip: "Highlighter",
            child: const Icon(Icons.highlight),
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
            onPressed: _selectPencil,
            tooltip: "Pencil",
            child: const Icon(Icons.edit),
          ),
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _buildSketch() {
    return Sketch(
      controller: _sketchController,
      scrollController: _scrollController,
    );
  }
}
