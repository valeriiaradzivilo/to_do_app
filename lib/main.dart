import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:to_do_app/data/database_blocks.dart';
import 'package:to_do_app/pages/to_do_list_page.dart';
import 'package:to_do_app/util/add_task_box.dart';
import 'package:to_do_app/util/task_block.dart';
import 'package:sizer/sizer.dart';



void main() async {
  // init the hive
  await Hive.initFlutter();
  var box = await Hive.openBox('ToDoAppBox');

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
        title: 'To do',
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
  ToDoBlocksDatabase db = ToDoBlocksDatabase();
  final _myBox = Hive.box("ToDoAppBox");

  final _TaskNameController = TextEditingController();


  @override
  void initState() {
    if (_myBox.get("BLOCKNAMES") == null) {
      db.createInitialData();
    } else {
      db.loadData();
    }
    // TODO: implement initState
    super.initState();
  }

  void createNewToDoListPage(){
    showDialog(
      context: context,
      builder: (context) {
        return DialogueBox(
          controller: _TaskNameController,
          onSave: saveNewToDo,
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  void saveNewToDo  ()async
  {
    db.BlocksNames.add(_TaskNameController.text);
    db.BlocksFirstTasks?.add(["Nothing yet"]);
    // await Hive.openBox(_TaskNameController.text);
    String textFromController = _TaskNameController.text;

    print("Created box named "+textFromController);
    Navigator.of(context).pop();
    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ToDoListPage(BoxName: textFromController)));


     db.updateDb();
    setState(() {
      _TaskNameController.clear();

    });

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
        onPressed: createNewToDoListPage,
        child: Icon(Icons.add),
      ),
      body:
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 300,
                      childAspectRatio: 3 / 3,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20),
                  itemCount: db.BlocksNames.length,
                  itemBuilder: (BuildContext ctx, index) {
                    return Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.teal,
                          borderRadius: BorderRadius.circular(15)),
                      child: TaskBlockMain(
                        name: db.BlocksNames.elementAt(index),
                        tasks: db.BlocksFirstTasks?.elementAt(index),
                      ),
                    );
                  }

              ),
            ),


    );

  }
}
