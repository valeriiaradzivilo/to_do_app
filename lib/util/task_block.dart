import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class TaskBlockMain extends StatelessWidget {
  final name;
  final List tasks;
  const TaskBlockMain({Key? key, this.name, required this.tasks})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: EdgeInsets.all(20),
        height: 20.h,
        width: 20.h,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12), color: Colors.teal),
        child: Column(
          children: [
            Text(
              name,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              textAlign: TextAlign.center,
            ),
            Expanded(
                child: Divider(
              color: Colors.blueGrey,
            )),
            ListView.builder(
                shrinkWrap: true,
                itemCount: 2,
                itemBuilder: (context, index) {
                  return Text(tasks.elementAt(index));
                })
          ],
        ),
      ),
    );
  }
}
