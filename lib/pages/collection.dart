import 'package:wallpaper/api.dart';
import 'package:flutter/material.dart';

class WallpaperCollection extends StatefulWidget {
  const WallpaperCollection({Key? key}) : super(key: key);

  @override
  _WallpaperCollectionState createState() => _WallpaperCollectionState();
}

class _WallpaperCollectionState extends State<WallpaperCollection> {
  var api = Api(10);
  @override
  void initState() {
    api.all()
    .then((value) => print(value));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}