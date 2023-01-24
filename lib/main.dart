import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:to_do_app/data/database.dart';
import 'package:to_do_app/util/add_task_box.dart';
import 'package:to_do_app/util/my_text.dart';
import 'package:to_do_app/util/task_block.dart';
import 'package:to_do_app/util/todo_tile.dart';
import 'package:sizer/sizer.dart';
import 'package:confetti/confetti.dart';
import 'dart:math';

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

  List ToDoBlocks = [["Help", ["me","you"]],["Homework", ["Math","Science"]],
  ["Zip's tasks",["Call mom", "Eat breakfast"]],
    ["Lera's tasks",["Dima", "Eat Dima"]]];

  void createNewToDoListPage(){

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
                      childAspectRatio: 3 / 2,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20),
                  itemCount: ToDoBlocks.length,
                  itemBuilder: (BuildContext ctx, index) {
                    return Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.teal,
                          borderRadius: BorderRadius.circular(15)),
                      child: TaskBlockMain(
                        name: ToDoBlocks.elementAt(index)[0],
                        tasks: ToDoBlocks.elementAt(index)[1],
                      ),
                    );
                  }

              ),
            ),


    );

  }
}
