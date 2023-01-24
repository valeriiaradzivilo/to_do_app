import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:to_do_app/data/database_blocks.dart';
import 'package:to_do_app/pages/to_do_list_page.dart';
import 'package:to_do_app/util/add_task_box.dart';
import 'package:to_do_app/util/task_block.dart';
import 'package:sizer/sizer.dart';

import 'data/database_tasks.dart';




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
  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }
  ToDoBlocksDatabase db = ToDoBlocksDatabase();
  final _myBox = Hive.box("ToDoAppBox");

  final _TaskNameController = TextEditingController();
  String errorMessageSave = "";
  final _formKey = GlobalKey<FormState>();


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
        return Column(
          children: [
            Form(
              key: _formKey,
              child: DialogueBox(
                controller: _TaskNameController,
                onSave: saveNewToDo,
                onCancel: () => Navigator.of(context).pop(),
                names: db.BlocksNames,
              ),
            ),
          ],
        );
      },
    );
  }






  void saveNewToDo  ()async
  {
    if(_formKey.currentState?.validate()==true) {
      String textFromController = _TaskNameController.text;

      db.BlocksNames.add(_TaskNameController.text);





      print("Created box named " + textFromController);
      Navigator.of(context).pop();
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ToDoListPage(BoxName: textFromController)));


      db.BlocksFirstTasks?.add([]);
      db.updateDb();
      setState(() {
        _TaskNameController.clear();
      });
    }
  }

  @override
  void deleteBlock(int index) async
  {
    print("long press");
    var box = await Hive.openBox(db.BlocksNames.elementAt(index).toLowerCase());
    await box.clear();
    db.BlocksNames.removeAt(index);
    db.BlocksFirstTasks?.removeAt(index);
    db.updateDb();
    restartApp();
    


  }

  void openToDoList(String boxName){
    print("tap");
    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ToDoListPage(BoxName: boxName)));
    
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key:key,
      child: Scaffold(
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
                      return
                         GestureDetector(
                          onTap: ()=>openToDoList(db.BlocksNames.elementAt(index)),
                          onLongPress:()=>deleteBlock(index),
                            child: TaskBlockMain(
                              name: db.BlocksNames.elementAt(index),
                              tasks: db.BlocksFirstTasks?.elementAt(index),
                            ),


                      );
                    }

                ),
              ),


      ),
    );

  }
}
