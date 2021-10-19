import 'package:flutter/services.dart';

class Permission {
  static const _platform = MethodChannel('com.foxdebug.wallpaper');

  static Future<bool> has(String permission) async {
    bool? res = await _platform.invokeMethod(
      "hasPermission",
      {"permission": permission},
    );

    return res ?? false;
  }

  static Future<bool> request(String permission) async {
    bool? res = await _platform.invokeMethod(
      "getPermission",
      {"permission": permission},
    );

    return res ?? false;
  }
}
