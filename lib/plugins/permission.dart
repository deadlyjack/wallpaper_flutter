import 'package:flutter/services.dart';

class Permission {
  static const _platform = MethodChannel('com.foxdebug.wallpaper');

  static Future<bool> has(String permission) async {
    return await _platform.invokeMethod(
      "hasPermission",
      {"permission": permission},
    );
  }

  static Future<bool> request(String permission) async {
    return await _platform.invokeMethod(
      "getPermission",
      {"permission": permission},
    );
  }
}
