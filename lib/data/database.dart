import 'package:hive/hive.dart';

class ToDoDatabase{
  List ToDoList = [];
  List DoneList = [];
  // reference the hive

  final _myBox = Hive.box('mybox');

  void createInitialData()
  {
    ToDoList = [["Make sandwich",false],
    ["Swipe left <=", false]];
    DoneList = [["I woke up )", true]];
  }

  void loadData()
  {
    print("loading db.......");
    ToDoList = _myBox.get("TODOLIST");
    DoneList = _myBox.get("DONELIST");
  }

  void updateDb()
  {
    print("updating db.....");
    _myBox.put("TODOLIST", ToDoList);
    _myBox.put("DONELIST", DoneList);
  }


}