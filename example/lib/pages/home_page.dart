import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sketcher/sketcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>with SingleTickerProviderStateMixin {
   final _sketchController = SketchController();
  final _scrollController = ScrollController();
    void _selectColor(Color color) {
    _sketchController.setActiveColor(color);
  }
   List<Offset> _points = <Offset>[];
AnimationController _animationController;
  @override
  void initState() {
_animationController=AnimationController(vsync: this,duration: const Duration(milliseconds:500));
    super.initState();
    print("initState()");
    _sketchController.addListener(() => setState(() {}));
  }
  Offset _offset = Offset(0, 0);
void _runAnimation()async{
  for(int i=0;i<100;i++){
    await _animationController.forward();
   
  }}

   Future<void> _showMyDialog() async {
     return showDialog<void>(
       context: context,
       barrierDismissible: false, // user must tap button!
       builder: (BuildContext context) {
         return AlertDialog(
           title: const Text('Time For Attendence',textAlign: TextAlign.center,style: TextStyle(color: Colors.indigo,),),

           content: SingleChildScrollView(
             child: ListBody(
               children:  <Widget>[
                 const SizedBox(
                   //Use of SizedBox
                   height: 35,
                 ),
                 Transform.scale(
                  scale: 5.0,
                   child: IconButton(
                       icon: Icon(Icons.notifications_active),

                    onPressed: () {
                      Navigator.of(context).pop();
                      //_runAnimation();

                      Fluttertoast.showToast(msg: 'Attendence marked',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM

                      )
                     ;
                    }
               

                      
                      const SizedBox(
                       //Use of SizedBox
                   height: 50,
                 ),

                 Row(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     Text('Tap it on!',textAlign: TextAlign.center,),
                     Icon(Icons.touch_app_rounded),//arrow_circle_up_rounded,navigation_rounded,touch_app_rounded
                   ],
                 ),//priority_high
                 Text('&',textAlign: TextAlign.center),
                //Icon(Icons.notifications_off ),
                 const SizedBox(
                   //Use of SizedBox
                   height: 10,
                 ),
                 Text('prove you are here!',textAlign: TextAlign.center),
               ],
             ),
           ),
           actions: <Widget>[
            
             IconButton(
               icon: const Icon(Icons.arrow_back_ios ),
               onPressed: () =>  Navigator.of(context).pop()
               
             ),


           ],
         );
       },
     );
   }
  

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.cleaning_services_rounded),
            onPressed: () => _sketchController.resetAllOperation(),
            //onPressed: () => _points.clear(),
          ),
          IconButton(
            icon: const Icon(Icons.auto_fix_high),
            onPressed: () => _sketchController.setActiveTool(SketchTool.spotlight),


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
              Container(
               
              decoration: const BoxDecoration(
              image: DecorationImage(image: AssetImage("lib/assets/teststudy.gif"), fit: BoxFit.cover,),

            ),
            ),

          SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            controller: _scrollController,
            child: SizedBox(height: 2000, child: _buildSketch()),
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
          IconButton(
            icon: const Icon(Icons.pan_tool_rounded),
            onPressed: _showMyDialog,
            
          ),

          const Spacer(),

          IconButton(
            icon: const Icon(Icons.blur_circular),// cut_outlined ,brightness_1_outlined,remove
            onPressed: () => _sketchController.setActiveTool(SketchTool.eraser),
          ),
          IconButton(
            icon: const Icon(Icons.border_color ),// colorize, create_rounded
            onPressed: () => _sketchController.setActiveTool(SketchTool.highlighter),

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

