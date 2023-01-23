import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/util/button_to_save.dart';

class DialogueBox extends StatelessWidget {
  final controller;
  VoidCallback onSave;
  VoidCallback onCancel;

  DialogueBox({Key? key, required this.controller,
  required this.onSave,
  required this.onCancel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(

      backgroundColor: Colors.teal[300],
        content: Container(

          height: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextField(
                controller: controller,
                decoration: InputDecoration(
                  border:  OutlineInputBorder(),
                  hintText: "New task",
                ),
              ),
              Row(
                children: [
                  myButton(name: "Save", onPressed: onSave),
                  const SizedBox(width: 10,),
                  myButton(name: "Cancel", onPressed: onCancel),
                ],
              )
            ],
          ),
        ),
    );
  }
}
