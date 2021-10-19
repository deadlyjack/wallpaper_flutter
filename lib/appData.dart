import 'package:wallpaper/api.dart';
import 'package:wallpaper/constants.dart';
import 'package:wallpaper/plugins/permission.dart';
import 'package:wallpaper/plugins/wallpaper.dart';

enum Status {NOT_LOADED, LOADING, LOADED}

class AppData{
  String homeImage = '';
  String lockImage = '';
  List<String> tags = [];
  bool hasReadPermission = false;
  bool initialized = false;
  Status status = Status.NOT_LOADED;
  Future<void> init() async{
    status = Status.LOADING;
    final api =  Api();

    tags = await api.tags();
    hasReadPermission = await Permission.has(Constants.READ_EXTERNAL_STORAGE);

    if(hasReadPermission){
      homeImage = await Wallpaper.getHomeWallpaperImage();
      lockImage = await Wallpaper.getLockWallpaperImage();
    }
    status = Status.LOADED;
  }
}