import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:to_do_app/data/database.dart';
import 'package:to_do_app/util/add_task_box.dart';
import 'package:to_do_app/util/my_text.dart';
import 'package:to_do_app/util/todo_tile.dart';
import 'package:sizer/sizer.dart';


void main() async {
  // init the hive
  await Hive.initFlutter();
  var box = await Hive.openBox('mybox');

  runApp(const MyToDoApp());
}



class MyToDoApp extends StatelessWidget {
  const MyToDoApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(
        builder: (context, orientation, deviceType)
    {
      return MaterialApp(
        title: 'To do list',
        theme: ThemeData(
          primarySwatch: Colors.teal,
        ),
        home: ToDoAppPage(),
      );
    }
    );
  }
}

class ToDoAppPage extends StatefulWidget {
  const ToDoAppPage({super.key});
  @override
  State<ToDoAppPage> createState() => _ToDoAppPageState();
}

class _ToDoAppPageState extends State<ToDoAppPage> {
  // reference hive box
  final _myBox = Hive.box('mybox');

  // text controller for new tasks
  final _controller = TextEditingController();

  ToDoDatabase db = ToDoDatabase();

  @override
  void initState() {
    if (_myBox.get("TODOLIST") == null) {
      db.createInitialData();
    } else {
      db.loadData();
    }
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
    });
    db.updateDb();
  }

  void saveNewTask() {
    setState(() {
      db.ToDoList.add([_controller.text, false]);
      Navigator.of(context).pop();
      _controller.clear();
    });
    db.updateDb();
  }

  void deleteTask(int index) {
    setState(() {
      db.ToDoList.removeAt(index);
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
                      deleteTask: (context) => deleteTask(index),
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
                      deleteTask: (context) => deleteTask(index),
                      paddingSize: 10,
                    );
                  },
                ),
              ),

            MainText(text:"You've done great job today! You made: "+(db.DoneList.length/(db.ToDoList.length+db.DoneList.length)*100).toString() +"% of work you planned."),


          ],
        ),

    );

  }
}
