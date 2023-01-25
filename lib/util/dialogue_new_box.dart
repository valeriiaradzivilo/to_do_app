import 'package:flutter/material.dart';
import 'package:to_do_app/util/button_to_save.dart';

class DialogueBox extends StatelessWidget {
  final controller;
  VoidCallback onSave;
  VoidCallback onCancel;
  final List names;

  DialogueBox({Key? key, required this.controller,
  required this.onSave,
  required this.onCancel, required this.names}) : super(key: key);
  String? validateNotEmpty(String ?value) {
    if (value==null || value.isEmpty) {
      return 'Field cannot be empty';
    }
    if(value.toString().contains('\n'))
      {
        return 'Field must not include new line character';
      }
    if(names.contains(value.toString()))
      {
        return 'You already have such note, please,\nchange the name or open (delete)\nthe old one.';
      }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.teal[300],
        content: Container(
          height: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextFormField(
                  controller: controller,
                  validator:validateNotEmpty,
                  decoration: const InputDecoration(
                    border:  OutlineInputBorder(),
                    hintText: "New task",
                  ),
                ),
              Row(
                children: [
                  MyButton(name: "Cancel", onPressed: onCancel),
                  const SizedBox(width: 10,),
                  MyButton(name: "Save", onPressed: onSave),

                ],
              )
            ],
          ),
        ),

    );
  }
}
