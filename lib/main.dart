import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wallpaper/appData.dart';
import 'package:wallpaper/pages/home.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper/themes.dart';

void main() async {
  runApp(
    MaterialApp(
      theme: ThemeData.dark(),
      title: 'Wallpaper',
      home: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
        ),
        child: Provider(
          create: (_) => AppData(),
          child: Home(),
        ),
      ),
    ),
  );
}
