import 'package:hive/hive.dart';
import 'package:to_do_app/data/database_tasks.dart';

class ToDoBlocksDatabase{
  List BlocksNames = [];
  List? BlocksFirstTasks;

  // reference the hive
  final _myBox= Hive.box('ToDoAppBox');
  void createInitialData()
  {
    BlocksNames = ["Hello"];
    BlocksFirstTasks = [["Make sandwich",
      "Swipe left <="]];
  }

  void loadData()
  {
    print("loading db.......");
    BlocksNames = _myBox.get("BLOCKNAMES");
    BlocksFirstTasks = _myBox.get("BLOCKSFIRSTTASKS");

  }

  void updateDb()
  async {
    print("updating db.....");
    _myBox.put("BLOCKNAMES", BlocksNames);
    _myBox.put("BLOCKSFIRSTTASKS", BlocksFirstTasks);
    print(BlocksFirstTasks.toString());
    print(BlocksNames.toString());
  }


}