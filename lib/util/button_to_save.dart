import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class myButton extends StatelessWidget {
  final String name;
  VoidCallback onPressed;
  myButton({super.key, required this.name,
  required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(onPressed: onPressed,
    color: Theme.of(context).primaryColor,
    child: Text(name),);
  }
}
