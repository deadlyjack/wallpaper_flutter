import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper/components/page.dart';
import 'package:wallpaper/components/splashScreen.dart';
import 'package:wallpaper/components/titleBar.dart';
import 'package:wallpaper/extensions.dart';
import 'package:wallpaper/pages/collection.dart';
import 'package:wallpaper/api.dart';
import 'package:wallpaper/appData.dart';
import 'package:wallpaper/components/alert.dart';
import 'package:wallpaper/components/thumbnail.dart';
import 'package:wallpaper/constants.dart';
import 'package:wallpaper/plugins/permission.dart';
import 'package:wallpaper/plugins/wallpaper.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final api = Api(10);

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<AppData>(context);
    if (data.status == Status.NOT_LOADED) {
      data.init().then((value) {
        setState(() {});
      });
      return splashScreen();
    }
    return page(
      body: homeBody(data),
      titleBar: titleBar(
        title: 'Wallpaper',
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
    );
  }

  Widget homeBody(AppData data) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        SizedBox(
          width: double.infinity,
        ),
        if (!data.hasReadPermission) ...[
          TextButton(
            style: TextButton.styleFrom(padding: EdgeInsets.zero),
            onPressed: () async {
              var permission =
                  await Permission.request(Constants.READ_EXTERNAL_STORAGE);
              data.hasReadPermission = permission;
              data.homeImage = await Wallpaper.getHomeWallpaperImage();
              data.lockImage = await Wallpaper.getLockWallpaperImage();
              setState(() {});
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
              padding: const EdgeInsets.only(bottom: 6.0),
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.start,
                direction: Axis.horizontal,
                children: buildCards(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> buildCards() {
    int count = 0;
    final data = Provider.of<AppData>(context);
    List<Widget> list = [
      Container(
        width: double.infinity,
      )
    ];

    if (data.hasReadPermission) {
      final homeImage = data.homeImage;
      final lockImage = data.lockImage;

      String label = 'Home Screen';

      if (homeImage.isNotEmpty && lockImage.isEmpty) {
        label = 'Home & Lock Screen';
      }

      if (homeImage.isNotEmpty) {
        final image = FileImage(File(homeImage));
        list.add(
          Thumbnail(
            index: ++count,
            image: image,
            label: label,
          ),
        );
      }

      if (lockImage.isNotEmpty) {
        final image = FileImage(File(lockImage));
        list.add(
          Thumbnail(
            index: ++count,
            image: image,
            label: 'Lock Screen',
          ),
        );
      }
    }

    for (var tag in data.tags) {
      list.add(Thumbnail(
        label: tag.capitalize(),
        index: ++count,
        color: Color(0xff1c1a32),
        futureImage: () async {
          final data = await Api(1).tag(tag);
          return NetworkImage(data[0].src.thumbnail);
        },
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WallpaperCollection(query: tag),
            ),
          );
        },
      ));
    }

    return list;
  }
}
