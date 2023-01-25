import 'package:hive/hive.dart';

class ToDoDatabase{
  String name="";
  List toDoList = [];
  List doneList = [];
  late final _myBox;
  // reference the hive

  ToDoDatabase(String boxName) {
    _myBox = Hive.box(boxName);
    if(_myBox.get("TODOLIST")!=null) {
      toDoList = _myBox.get("TODOLIST");
    }
    else{
      toDoList = [];
    }
    if(_myBox.get("DONELIST")!=null) {
      doneList = _myBox.get("DONELIST");
    }
    else{
      doneList = [];
    }
    name = boxName;
  }

  void createInitialData()
  {
    toDoList = [ ["Swipe left <=", false]];
    doneList = [["This task is done", true]];
  }

  void loadData()
  {
    toDoList = _myBox.get("TODOLIST");
    doneList = _myBox.get("DONELIST");
  }

  void updateDb()
  {
    _myBox.put("TODOLIST", toDoList);
    _myBox.put("DONELIST", doneList);
  }


}