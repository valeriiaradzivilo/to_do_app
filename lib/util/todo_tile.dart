import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ToDoTile extends StatelessWidget {
  final String taskName;
  final bool taskComplete;
  Function(bool?)? onChanged;
  Function(BuildContext)? deleteTask;
  double paddingSize;
  ToDoTile(
      {Key? key,
      required this.taskName,
      required this.taskComplete,
      required this.onChanged,
      required this.deleteTask,
      required this.paddingSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          top: paddingSize, left: paddingSize, right: paddingSize),
      child: Slidable(
        endActionPane: ActionPane(
          motion: StretchMotion(),
          children: [
            SlidableAction(
              onPressed: deleteTask,
              icon: Icons.delete_forever_rounded,
              backgroundColor: Colors.redAccent,
              borderRadius: BorderRadius.circular(12),
            )
          ],
        ),
        child: Container(
          padding: EdgeInsets.all(paddingSize - 1),
          decoration: BoxDecoration(
            color: Colors.teal[300],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Checkbox(value: taskComplete, onChanged: onChanged),
              Expanded(
                child: Text(taskName,
                    overflow: TextOverflow.clip,
                    style: TextStyle(
                        decoration: taskComplete
                            ? TextDecoration.lineThrough
                            : TextDecoration.none)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
