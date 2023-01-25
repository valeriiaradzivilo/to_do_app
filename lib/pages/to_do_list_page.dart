import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:to_do_app/data/database_tasks.dart';
import 'package:to_do_app/util/dialogue_new_box.dart';
import 'package:to_do_app/util/my_text.dart';
import 'package:to_do_app/util/todo_tile.dart';
import 'package:confetti/confetti.dart';
import 'dart:math';


class ToDoListPage extends StatefulWidget {
  final int indexBox;
  final String boxName;
  final List? blocksFirstTasks;

  const ToDoListPage({super.key, required this.boxName, required this.blocksFirstTasks, required this.indexBox});
  @override
  State<ToDoListPage> createState() => _ToDoListPageState();
}

class _ToDoListPageState extends State<ToDoListPage> {
  List toDo = [];
  List done = [];
  late ToDoDatabase db;

  // controller for fireworks
  final ConfettiController _centerController =
      ConfettiController(duration: const Duration(seconds: 1));
  late double percentDone = 0;

  // reference hive box
  late final _myBox;

  // text controller for new tasks
  final _controller = TextEditingController();

  var box = null;

  Future<String> openBoxMy() async {
    if (box == null) {
      Hive.initFlutter(); // Initialize Hive
      box = await Hive.openBox(widget.boxName); // Open the box
      _myBox = await Hive.box(widget.boxName);
      db = ToDoDatabase(widget.boxName);
    }

    if (_myBox.get("TODOLIST") == null) {
      db.createInitialData();
    } else {
      db.loadData();
    }

    toDo = db.toDoList;
    done = db.doneList;
    percentDone =
        db.doneList.length / (db.toDoList.length + db.doneList.length);
    if (percentDone ==   1) {
      _centerController.play();
    } else {
      _centerController.stop();
    }
    return 'Opened box';
  }

  @override
  void initState() {

    super.initState();
  }

  void checkboxChanged(bool? value, int index, bool isToDo) {
    setState(() {
      if (isToDo) {
        db.toDoList.elementAt(index)[1] = !db.toDoList.elementAt(index)[1];
        db.doneList.add(db.toDoList.elementAt(index));
        db.toDoList.removeAt(index);
      } else {
        db.doneList.elementAt(index)[1] = !db.doneList.elementAt(index)[1];
        db.toDoList.add(db.doneList.elementAt(index));
        db.doneList.removeAt(index);
      }
      if (percentDone ==  1) {
        _centerController.play();
      } else {
        _centerController.stop();
      }
    });
    db.updateDb();
    widget.blocksFirstTasks?.removeAt(widget.indexBox);
    if(db.toDoList.length>1) {
      widget.blocksFirstTasks?.insert(
          widget.indexBox, [db.toDoList.elementAt(0)[0],db.toDoList.elementAt(1)[0],"..."]);
    }
    else if(db.toDoList.isNotEmpty)
    {
      widget.blocksFirstTasks?.insert(
          widget.indexBox, [db.toDoList.elementAt(0)[0]]);
    }
    else{
      widget.blocksFirstTasks?.insert(
          widget.indexBox, ["Nothing to do"]);
    }
  }

  @override
  void dispose() {
    // dispose the controller
    _centerController.dispose();
    super.dispose();
  }

  void saveNewTask() {
    setState(() {
      db.toDoList.add([_controller.text, false]);
      Navigator.of(context).pop();
      _controller.clear();
    });
    db.updateDb();

    widget.blocksFirstTasks?.removeAt(widget.indexBox);
    if(db.toDoList.length>1) {
      widget.blocksFirstTasks?.insert(
          widget.indexBox, [db.toDoList.elementAt(0)[0],db.toDoList.elementAt(1)[0],"..."]);
    }
    else if(db.toDoList.isNotEmpty)
      {
        widget.blocksFirstTasks?.insert(
            widget.indexBox, [db.toDoList.elementAt(0)[0]]);
      }
    else{
      widget.blocksFirstTasks?.insert(
          widget.indexBox, ["Nothing to do"]);
    }
  }

  void deleteTask(int index, bool isToDo) {
    setState(() {
      if (isToDo) {
        db.toDoList.removeAt(index);
      } else {
        db.doneList.removeAt(index);
      }
    });
    db.updateDb();

    widget.blocksFirstTasks?.removeAt(widget.indexBox);
    if(db.toDoList.length>1) {
      widget.blocksFirstTasks?.insert(
          widget.indexBox, [db.toDoList.elementAt(0)[0],db.toDoList.elementAt(1)[0],"..."]);
    }
    else if(db.toDoList.isNotEmpty)
    {
      widget.blocksFirstTasks?.insert(
          widget.indexBox, [db.toDoList.elementAt(0)[0]]);
    }
    else{
      widget.blocksFirstTasks?.insert(
          widget.indexBox, ["Nothing to do"]);
    }
  }

  void createNewTask() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogueBox(
          controller: _controller,
          onSave: saveNewTask,
          onCancel: () => Navigator.of(context).pop(),
          names: const [],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: Colors.tealAccent,
        appBar: null,
        floatingActionButton: FloatingActionButton(
          onPressed: createNewTask,
          child: const Icon(Icons.add),
        ),
        body: FutureBuilder<String>(
            future: openBoxMy(),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              List<Widget> children;

              if (snapshot.hasData) {
                children = <Widget>[
                  Align(
                    alignment: Alignment.center,
                    child: ConfettiWidget(
                      confettiController: _centerController,
                      blastDirection: pi / 2,
                      maxBlastForce: 5,
                      minBlastForce: 1,
                      emissionFrequency: 0.01,

                      // particles will pop-up at a time
                      numberOfParticles: 30,

                      // particles will come down
                      gravity: 1,

                      // start again as soon as the
                      // animation is finished
                      shouldLoop: false,

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
                  Expanded(
                    child: CustomScrollView(slivers: <Widget>[
                      SliverAppBar(
                        stretch: true,
                        expandedHeight: widget.boxName.length.toDouble()*3,
                        flexibleSpace: FlexibleSpaceBar(
                          stretchModes: const <StretchMode>[
                            StretchMode.zoomBackground,
                            StretchMode.blurBackground,
                            StretchMode.fadeTitle,
                          ],
                          centerTitle: true,
                          title: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(widget.boxName,
                              overflow: TextOverflow.visible,),
                          ),

                        ),
                      ),
                      const SliverToBoxAdapter(
                        child: MainText(text: "To do:"),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.all(4.0),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              return ToDoTile(
                                taskName: toDo.elementAt(index)[0],
                                taskComplete: toDo.elementAt(index)[1],
                                onChanged: (value) =>
                                    checkboxChanged(value, index, true),
                                deleteTask: (context) =>
                                    deleteTask(index, true),
                                paddingSize: 25,
                              );
                            },
                            childCount: toDo.length,
                          ),
                        ),
                      ),
                      const SliverToBoxAdapter(
                        child: MainText(text: "Done:"),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.all(4.0),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              return ToDoTile(
                                taskName: done.elementAt(index)[0],
                                taskComplete: done.elementAt(index)[1],
                                onChanged: (value) =>
                                    checkboxChanged(value, index, false),
                                deleteTask: (context) =>
                                    deleteTask(index, false),
                                paddingSize: 10,
                              );
                            },
                            childCount: done.length,
                          ),
                        ),
                      ),
                    ]),
                  ),
                  MainText(
                      text: percentDone == 1
                          ? "You've done great job today!"
                          : ""),
                  MainText(
                      text: percentDone.isNaN
                          ? "You haven't planned anything yet."
                          : "You made: ${(percentDone* 100).toInt() }% of work you planned."),

                ];
              } else if (snapshot.hasError) {
                children = <Widget>[
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 60,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text('Error: ${snapshot.error}'),
                  ),
                ];
              } else {
                children = const <Widget>[
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: CircularProgressIndicator(),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text('Awaiting result...'),
                  ),
                ];
              }
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: children,
                ),
              );
            }));
  }
}
