import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:to_do_app/data/database_blocks.dart';
import 'package:to_do_app/pages/to_do_list_page.dart';
import 'package:to_do_app/util/DialogueCheck.dart';
import 'package:to_do_app/util/dialogue_new_box.dart';
import 'package:to_do_app/util/task_block.dart';
import 'package:sizer/sizer.dart';





void main() async {
  // init the hive
  await Hive.initFlutter();
  await Hive.openBox('ToDoAppBox');

  runApp(const MyToDoApp());
}



class MyToDoApp extends StatelessWidget {
  const MyToDoApp({super.key});


  @override
  Widget build(BuildContext context) {
    // sizer to make app adaptive
    return Sizer(
        builder: (context, orientation, deviceType)
    {
      return MaterialApp(
        title: 'To do',
        theme: ThemeData(
          primarySwatch: Colors.teal,
        ),
        home: const ToDoAppPage(),
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
  // this key is used for restart
  Key key = UniqueKey();

  // restart page to submit changes
  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  // opening box in hive and assigning database
  ToDoBlocksDatabase db = ToDoBlocksDatabase();
  final _myBox = Hive.box("ToDoAppBox");

  // text controller for input of name of box
  final _taskNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();


  @override
  void initState() {
    // load db or create inital data
    if (_myBox.get("BLOCKNAMES") == null) {
      db.createInitialData();
    } else {
      db.loadData();
    }
    super.initState();
    restartApp();
  }

  // dialogue with input from user to get name of block
  void createNewToDoListPage(){
    showDialog(
      context: context,
      builder: (context) {
        return Column(
          children: [
            Form(
              key: _formKey,
              child: DialogueBox(
                controller: _taskNameController,
                onSave: saveNewToDo,
                onCancel: () => Navigator.of(context).pop(),
                names: db.blocksNames,
              ),
            ),
          ],
        );
      },
    );
  }



  // on save for dialogue createNewToDoListPage()
  void saveNewToDo  ()async
  {
    if(_formKey.currentState?.validate()==true) {
      String textFromController = _taskNameController.text;

      db.blocksNames.add(_taskNameController.text);


      int indexBox = db.blocksNames.length-1;
      db.blocksFirstTasks?.add(["Nothing yet"]);
      Navigator.of(context).pop();
      await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ToDoListPage(boxName: textFromController,
          indexBox: indexBox, blocksFirstTasks: db.blocksFirstTasks,)));


      db.updateDb();
      setState(() {
        _taskNameController.clear();
      });
      restartApp();
    }
  }

  // on long press block is deleted
  void deleteBlock(int index) async
  {
    var box = await Hive.openBox(db.blocksNames.elementAt(index).toLowerCase());
    await box.clear();
    db.blocksNames.removeAt(index);
    db.blocksFirstTasks?.removeAt(index);
    db.updateDb();
    restartApp();
    Navigator.of(context).pop();

  }


  // open to do list with this name
  void openToDoList(String boxName, int index) async {
    await Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ToDoListPage(boxName: boxName, blocksFirstTasks: db.blocksFirstTasks,indexBox: index,)));
    restartApp();
  }

  void onLongPressOnBox(int index)
  {
    showDialog(
      context: context,
      builder: (context) {
        return Column(
          children: [
              DialogueCheck(
                controller: _taskNameController,
                onYes: ()=>deleteBlock(index),
                onNo: () => Navigator.of(context).pop(),
              ),
          ],
        );
      },
    );
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
          child: const Icon(Icons.add),
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
                    itemCount: db.blocksNames.length,
                    itemBuilder: (BuildContext ctx, index) {
                      return
                         GestureDetector(
                          onTap: ()=>openToDoList(db.blocksNames.elementAt(index), index),
                          onLongPress:()=>onLongPressOnBox(index),
                            child: TaskBlockMain(
                              name: db.blocksNames.elementAt(index),
                              tasks: db.blocksFirstTasks?.elementAt(index),
                            ),


                      );
                    }

                ),
              ),


      ),
    );

  }
}
