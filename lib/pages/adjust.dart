import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wallpaper/components/page.dart';
import 'package:wallpaper/components/titleBar.dart';

class AdjustWallpaper extends StatefulWidget {
  final String src;
  final double height;
  final double width;
  final Color color;

  const AdjustWallpaper({
    Key? key,
    required this.src,
    required this.height,
    required this.width,
    required this.color,
  }) : super(key: key);

  @override
  _AdjustWallpaperState createState() => _AdjustWallpaperState();
}

class _AdjustWallpaperState extends State<AdjustWallpaper> {
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double height = size.height * 0.7;
    double width = size.width * 0.7;
    double minScale = widget.height/height;

    print(minScale);

    return page(
      titleBar: titleBar(
        title: '',
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Container(
            height: height,
            width: width,
            color: widget.color,
            child: InteractiveViewer(
              maxScale: double.infinity,
              child: Image.network(
                widget.src,
                // fit: BoxFit.cover,
                loadingBuilder: (_, child, loadingProgress) {
                  if (mounted && loadingProgress == null) {
                    return child;
                  }
                  double? value;
                  int total = loadingProgress!.expectedTotalBytes ?? 0;
                  int loaded = loadingProgress.cumulativeBytesLoaded;

                  if(total > 0){
                    value = loaded/total;
                  }

                  return Center(
                    child: CircularProgressIndicator(
                      value: value,
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
