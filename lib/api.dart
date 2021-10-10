import 'dart:convert';
import 'package:http/http.dart' as http;

class Api{
  final String base = 'https://wallpaper.foxdebug.com';
  final num pageSize;
  Api(this.pageSize);

  Future<List> all({int page = 0}) async{
    Uri uri = Uri.parse('$base/images/all?page=$page&count=$pageSize');
    final result = await http.get(uri);
    return json.decode(result.body);
  }

  Future<List<String>> tags() async{
    Uri uri = Uri.parse('$base/collections');
    final result = await http.get(uri);
    return json.decode(result.body);
  }
}