import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wallpaper/ThemeColor.dart';
import 'package:wallpaper/api.dart';
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

  final api = Api(10);
  var hasReadPermission = false;
  String homeImage = '';
  String lockImage = '';

  @override
  void initState() {
    init();
    super.initState();
  }

  void init() async {
    hasReadPermission = await Permission.has(READ_EXTERNAL_STORAGE);
    homeImage = await Wallpaper.getHomeWallpaperImage();
    lockImage = await Wallpaper.getLockWallpaperImage();
    if (mounted) {
      setState(() {});
    }
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
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(
            width: double.infinity,
          ),
          if (!hasReadPermission) ...[
            TextButton(
              style: TextButton.styleFrom(padding: EdgeInsets.zero),
              onPressed: () async {
                var permission =
                    await Permission.request(READ_EXTERNAL_STORAGE);
                setState(() => hasReadPermission = permission);
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
            )
          ],
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: const EdgeInsets.only(top: 6.0),
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.start,
                  direction: Axis.horizontal,
                  children: buildCards(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> buildCards() {
    List<Widget> list = [
      Container(
        width: double.infinity,
      )
    ];
    String label = 'Home Screen';

    if (homeImage.isNotEmpty && lockImage.isEmpty) {
      label = 'Home & Lock Screen';
    }

    if (homeImage.isNotEmpty) {
      final image = FileImage(File(homeImage));
      list.add(
        card(
          context,
          1,
          image: image,
          label: label,
        ),
      );
    }

    if (lockImage.isNotEmpty) {
      final image = FileImage(File(lockImage));
      list.add(
        card(
          context,
          2,
          image: image,
          label: 'Lock Screen',
        ),
      );
    }

    return list;
  }
}
