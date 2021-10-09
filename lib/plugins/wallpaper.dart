import 'package:flutter/services.dart';

class Wallpaper {
  static const _platform = MethodChannel('com.foxdebug.wallpaper');

  static Future<String> getAll() async {
    String wallpaper;

    try {
      wallpaper = await _platform.invokeMethod('getHomeScreenWallpaper');
    } on PlatformException catch (e) {
      wallpaper = "Failed to get wallpaper: '${e.message}'.";
    }

    return wallpaper;
  }
}
