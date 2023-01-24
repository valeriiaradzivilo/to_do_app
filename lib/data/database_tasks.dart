import 'package:hive/hive.dart';

class ToDoDatabase{
  String Name="";
  List ToDoList = [];
  List DoneList = [];
  late final _myBox;
  // reference the hive

  ToDoDatabase(String boxName) {
    _myBox = Hive.box(boxName);
    if(_myBox.get("TODOLIST")!=null) {
      ToDoList = _myBox.get("TODOLIST");
    }
    else{
      ToDoList = [];
    }
    if(_myBox.get("DONELIST")!=null) {
      DoneList = _myBox.get("DONELIST");
    }
    else{
      DoneList = [];
    }
    Name = boxName;
  }

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