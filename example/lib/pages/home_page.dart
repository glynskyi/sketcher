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
  Offset _offset = Offset(0, 0);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),//check_circle_rounded
            onPressed: _sketchController.isRedoAvailable ? () => _sketchController.redo() : null,
          ),

          IconButton(
            icon: const Icon(Icons.chrome_reader_mode),//check_circle_rounded
            onPressed: _sketchController.isRedoAvailable ? () => _sketchController.redo() : null,
          ),
          SizedBox(width: 20),
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
        fit: StackFit.expand,
        children: [
          SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            controller: _scrollController,
            child: SizedBox(height: 2000, child: _buildSketch()),
          ),
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
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(width: 20),
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
//           IconButton(
//             icon: const Icon(Icons.cleaning_services_rounded),// restart_alt
//             onPressed: () => _sketchController.setActiveTool(SketchTool.resetall),
//           ),
          IconButton(
            icon: const Icon(Icons.blur_circular),// brightness_1_outlined,remove
            onPressed: () => _sketchController.setActiveTool(SketchTool.eraser),
          ),
          IconButton(
            icon: const Icon(Icons.border_color ),// colorize, create_rounded
            onPressed: () => _sketchController.setActiveTool(SketchTool.highlighter),

         ),
            IconButton(
            icon: const Icon(Icons.animation),//all_out, auto_awesome_rounded,auto_fix_high,camera, camera_outlined
            onPressed: () => _sketchController.setActiveTool(SketchTool.spotlight),


         ),


          IconButton(
            icon: const Icon(Icons.edit),//create_outlined
            onPressed: () => _sketchController.setActiveTool(SketchTool.pencil),
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







