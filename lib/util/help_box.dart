import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HelpBox extends StatelessWidget {
  const HelpBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.teal[300],
      content: const Text("Hi, thank you for using this app.\nTo delete box with tasks - long press on this box.\nTo delete a task - swipe this task left.\n To add task/box tap on '+' button in the bottom-left corner."),
    );
  }
}
