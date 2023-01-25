import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import 'button_to_save.dart';

class DialogueCheck extends StatelessWidget {
  final controller;
  VoidCallback onYes;
  VoidCallback onNo;
  DialogueCheck({Key? key, required this.controller, required this.onYes, required this.onNo}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.redAccent,
      content: Container(
        height: 30.h,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Are you sure you want to delete task box?",
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold,
            fontSize: 7.w),),
            Row(
              children: [
                MyButton(name: "No", onPressed: onNo),
                SizedBox(width: 20.w,),
                MyButton(name: "Yes", onPressed: onYes),
              ],
            )
          ],
        ),
      ),

    );
  }
}
