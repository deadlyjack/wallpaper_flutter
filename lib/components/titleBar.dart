import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

AppBar titleBar({
  List<Widget>? actions,
  Widget? leading,
  required String title,
}) {
  return AppBar(
    toolbarHeight: 60.0,
    shadowColor: Color(0xff000000),
    title: Text(
      title,
      style: TextStyle(
        fontSize: 14.0,
        color: Color(0x88ffffff),
      ),
    ),
    actions: actions,
    leading: leading,
  );
}
