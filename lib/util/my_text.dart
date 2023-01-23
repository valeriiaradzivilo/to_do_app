import 'package:flutter/cupertino.dart';
import 'package:sizer/sizer.dart';

class MainText extends StatelessWidget {
  final text;
  const MainText({Key? key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(text,
    style: TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 5.w),
    );
  }
}
