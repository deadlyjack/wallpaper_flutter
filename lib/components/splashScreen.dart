import 'package:flutter/cupertino.dart';

Container splashScreen() {
  return Container(
    height: double.infinity,
    width: double.infinity,
    color: Color(0xff331122),
    child: Center(
      child: Text(
        'Wallpaper',
        style: TextStyle(
          color: Color(0xffffffff),
          fontSize: 16.0,
          decoration: TextDecoration.none
        ),
      ),
    ),
  );
}
