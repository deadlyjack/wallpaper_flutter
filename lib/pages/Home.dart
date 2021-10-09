import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wallpaper/ThemeColor.dart';
import 'package:wallpaper/components/alert.dart';
import 'package:wallpaper/components/card.dart';
import 'package:wallpaper/plugins/permission.dart';
import 'package:wallpaper/plugins/wallpaper.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static const READ_EXTERNAL_STORAGE =
      'android.permission.READ_EXTERNAL_STORAGE';

  var hasReadPermission = false;

  @override
  void initState() {
    Permission.has(READ_EXTERNAL_STORAGE).then((value) {
      hasReadPermission = value;
      print(hasReadPermission);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColor.primaryColor,
      appBar: AppBar(
        toolbarHeight: 60.0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        shadowColor: Color(0xff000000),
        backgroundColor: ThemeColor.primaryColor,
        title: Text(
          'Wallpaper',
          style: TextStyle(
            fontSize: 14.0,
            color: Color(0x88ffffff),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              var wallpaper = await Wallpaper.getAll();
              alert(context, content: wallpaper);
            },
            icon: Icon(Icons.search),
          ),
          IconButton(
            onPressed: () => {},
            icon: Icon(Icons.settings),
          )
        ],
      ),
      body: Column(
        children: [
          TextButton(
            style: TextButton.styleFrom(padding: EdgeInsets.zero),
            onPressed: () async {
              setState(() async {
                hasReadPermission =
                    await Permission.request(READ_EXTERNAL_STORAGE);
              });
            },
            child: Container(
              height: 60.0,
              color: Color(0xff993333),
              child: Center(
                child: Text(
                  'Read permission not granted',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                card(),
                card(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
