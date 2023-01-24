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
        padding: EdgeInsets.only(top:20,
        left: 20, right: 20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12), color: Colors.teal),
        child: Column(
          children: [
            Text(
              name,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              textAlign: TextAlign.center,
            ),
          const Divider(
              color: Colors.blueGrey,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: 2,
                  itemBuilder: (context, index) {
                    return Text(tasks.elementAt(index));
                  }),
            )
          ],
        ),
      ),
    );
  }
}
