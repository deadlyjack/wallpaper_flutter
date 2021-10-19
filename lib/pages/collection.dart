import 'package:wallpaper/api.dart';
import 'package:flutter/material.dart';
import 'package:wallpaper/components/page.dart';
import 'package:wallpaper/components/titleBar.dart';
import 'package:wallpaper/components/wallpaperCard.dart';
import 'package:wallpaper/extensions.dart';
import 'package:wallpaper/pages/adjust.dart';

class WallpaperCollection extends StatefulWidget {
  final String query;

  const WallpaperCollection({Key? key, required this.query}) : super(key: key);

  @override
  _WallpaperCollectionState createState() => _WallpaperCollectionState();
}

class _WallpaperCollectionState extends State<WallpaperCollection> {
  var api = Api(20);
  List<WallpaperData>? wallpapers;

  @override
  void initState() {
    api.tag(widget.query).then((value) {
      setState(() {
        wallpapers = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> column1 = [];
    List<Widget> column2 = [];
    double width = MediaQuery.of(context).size.width - 15;
    bool switchFlag = false;
    if (wallpapers != null) {
      for (var wallpaper in wallpapers!) {
        final ratio = (width / 2) / wallpaper.width;
        final card = wallpaperCard(
          imageSrc: wallpaper.src.thumbnail,
          height: wallpaper.height * ratio,
          width: wallpaper.width * ratio,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AdjustWallpaper(
                  height: wallpaper.height,
                  width: wallpaper.width,
                  color: wallpaper.avgColor,
                  src: wallpaper.src.original,
                ),
              ),
            );
          },
        );
        if (switchFlag)
          column1.add(card);
        else
          column2.add(card);
        switchFlag = !switchFlag;
      }
    }
    return page(
      titleBar: titleBar(
        title: widget.query.capitalize(),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(5, 5, 2.5, 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: column1,
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(2.5, 5, 5, 2),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: column2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
