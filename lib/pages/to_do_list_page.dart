import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:to_do_app/data/database.dart';
import 'package:to_do_app/util/add_task_box.dart';
import 'package:to_do_app/util/my_text.dart';
import 'package:to_do_app/util/todo_tile.dart';
import 'package:sizer/sizer.dart';
import 'package:confetti/confetti.dart';
import 'dart:math';

class ToDoListPage extends StatefulWidget {
  const ToDoListPage({super.key});
  @override
  State<ToDoListPage> createState() => _ToDoListPageState();
}

class _ToDoListPageState extends State<ToDoListPage> {
  late ConfettiController _centerController;
  // reference hive box
  final _myBox = Hive.box('mybox');

  // text controller for new tasks
  final _controller = TextEditingController();

  ToDoDatabase db = ToDoDatabase();

  late double percentDone= db.DoneList.length/(db.ToDoList.length+db.DoneList.length);


  @override
  void initState() {
    if (_myBox.get("TODOLIST") == null) {
      db.createInitialData();
    } else {
      db.loadData();
    }
    _centerController =
        ConfettiController(duration: const Duration(seconds: 1));
    percentDone = db.DoneList.length/(db.ToDoList.length+db.DoneList.length);
    super.initState();
  }

  void CheckboxChanged(bool? value, int index, bool isToDo) {
    setState(() {
      if(isToDo) {
        db.ToDoList.elementAt(index)[1] = !db.ToDoList.elementAt(index)[1];
        db.DoneList.add(db.ToDoList.elementAt(index));
        db.ToDoList.removeAt(index);
      }
      else{
        db.DoneList.elementAt(index)[1]=!db.DoneList.elementAt(index)[1];
        db.ToDoList.add(db.DoneList.elementAt(index));
        db.DoneList.removeAt(index);
      }
      if((db.DoneList.length/(db.ToDoList.length+db.DoneList.length))==1) {
        _centerController.play();

      }
      else{
        _centerController.stop();
      }
    });
    db.updateDb();
  }
  @override
  void dispose() {

    // dispose the controller
    _centerController.dispose();
    super.dispose();
  }

  void saveNewTask() {
    setState(() {
      db.ToDoList.add([_controller.text, false]);
      Navigator.of(context).pop();
      _controller.clear();
    });
    db.updateDb();
  }

  void deleteTask(int index, bool isToDo) {
    setState(() {
      if(isToDo) {
        db.ToDoList.removeAt(index);
      }
      else{
        db.DoneList.removeAt(index);
      }
    });
    db.updateDb();
  }

  void createNewTask() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogueBox(
          controller: _controller,
          onSave: saveNewTask,
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.tealAccent,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Tasks for today",
        ),
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewTask,
        child: Icon(Icons.add),
      ),
      body:
      Column(
        children: [
          Align(
            alignment:

            // confetti will pop from top-center
            Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _centerController,
              blastDirection: pi / 2,
              maxBlastForce: 5,
              minBlastForce: 1,
              emissionFrequency: 0.01,

              // 10 paticles will pop-up at a time
              numberOfParticles: 20,

              // particles will come down
              gravity: 1,

              // start again as soon as the
              // animation is finished
              shouldLoop:false,

              // assign colors of any choice
              colors: const [
                Colors.green,
                Colors.tealAccent,
                Colors.greenAccent,
                Colors.lightGreenAccent,
                Colors.teal
              ],
            ),
          ),
          MainText(text:"To do:"),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: db.ToDoList.length,
              itemBuilder: (context, index) {
                return ToDoTile(
                  taskName: db.ToDoList.elementAt(index)[0],
                  taskComplete: db.ToDoList.elementAt(index)[1],
                  onChanged: (value) => CheckboxChanged(value, index,true),
                  deleteTask: (context) => deleteTask(index,true),
                  paddingSize: 25,
                );
              },
            ),
          ),


          const Divider(color: Colors.teal,),
          MainText(text:"Done tasks:"),
          Expanded(
            child: ListView.builder(
              itemCount: db.DoneList.length,
              itemBuilder: (context, index) {
                return ToDoTile(
                  taskName: db.DoneList.elementAt(index)[0],
                  taskComplete: db.DoneList.elementAt(index)[1],
                  onChanged: (value) => CheckboxChanged(value, index, false),
                  deleteTask: (context) => deleteTask(index,false),
                  paddingSize: 10,
                );
              },
            ),
          ),

          MainText(text:percentDone==1?"You've done great job today!":""),
          MainText(text:percentDone.isNaN?"You haven't planned anything yet.":"You made: ${percentDone!*100}% of work you planned."),
          // align the confetti on the screen



        ],
      ),

    );

  }
}
