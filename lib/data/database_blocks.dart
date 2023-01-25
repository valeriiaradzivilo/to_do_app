import 'package:hive/hive.dart';

class ToDoBlocksDatabase{
  List blocksNames = [];
  List? blocksFirstTasks;

  // reference the hive
  final _myBox= Hive.box('ToDoAppBox');
  void createInitialData()
  {
    blocksNames = ["Hello"];
    blocksFirstTasks = [["Make sandwich",
      "Swipe left <="]];
  }

  void loadData()
  {
    blocksNames = _myBox.get("BLOCKNAMES");
    blocksFirstTasks = _myBox.get("BLOCKSFIRSTTASKS");

  }

  void updateDb()
  async {
    _myBox.put("BLOCKNAMES", blocksNames);
    _myBox.put("BLOCKSFIRSTTASKS", blocksFirstTasks);
  }


}