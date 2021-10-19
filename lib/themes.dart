import 'package:flutter/material.dart';

class Themes {
  static ThemeData dark(){
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: Color(0x212028),
      primaryColorBrightness: Brightness.dark,
      colorScheme: ColorScheme.dark(),
    );
  }
}
