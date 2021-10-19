import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class Api {
  final String base = 'https://wallpaper.foxdebug.com';
  final int pageSize;

  Api([this.pageSize = 0]);

  Future<List<WallpaperData>> all({int page = 0, int? count}) async {
    if (count == null) count = this.pageSize;
    Uri uri = Uri.parse('$base/images/all?page=$page&count=$count');
    final result = (await http.get(uri)).body;
    return _parseData(result);
  }

  Future<List<String>> tags() async {
    Uri uri = Uri.parse('$base/collections');
    final result = await http.get(uri);
    List tagList;
    late List<String> tags;

    tagList = json.decode(result.body);
    tags = tagList.map((e) => e as String).toList();
    tags.shuffle();
    return tags;
  }

  Future<List<WallpaperData>> tag(
    String tagName, {
    int page = 0,
    int? count,
  }) async {
    if (count == null) count = this.pageSize;
    String url = "$base/collection/$tagName?page=$page&count=$count";
    Uri uri = Uri.parse(url);
    final result = (await http.get(uri)).body;
    return _parseData(result);
  }

  List<WallpaperData> _parseData(String data) {
    final list = json.decode(data);
    List<WallpaperData> res = [];
    for (var obj in list) {
      res.add(WallpaperData.fromJson(obj));
    }
    return res;
  }
}

class WallpaperData {
  late double height;
  late double width;
  late Color avgColor;
  late String id;
  late Meta meta;
  late Src src;

  WallpaperData({
    required this.height,
    required this.width,
    required String avgColor,
    required this.id,
    required this.meta,
    required this.src,
  }) {
    this.avgColor = fromRGB(avgColor);
  }

  WallpaperData.fromJson(Map<String, dynamic> json) {
    height = json['height'].toDouble();
    width = json['width'].toDouble();
    avgColor = fromRGB(json['avgColor']);
    id = json['id'];
    meta = Meta.fromJson(json['meta']);
    src = Src.fromJson(json['src']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['height'] = this.height;
    data['width'] = this.width;
    data['avgColor'] = this.avgColor.toString();
    data['id'] = this.id;
    data['meta'] = this.meta.toJson();
    data['src'] = this.src.toJson();
    return data;
  }
}

class Meta {
  late List<String> tags;
  late String website;
  late String email;
  late String author;

  Meta({
    required this.tags,
    required this.website,
    required this.email,
    required this.author,
  });

  Meta.fromJson(Map<String, dynamic> json) {
    tags = json['tags'].cast<String>();
    website = json['website'] == null ? '' : json['website'];
    email = json['email'] == null ? '' : json['email'];
    author = json['author'] == null ? '' : json['author'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tags'] = this.tags;
    data['website'] = this.website;
    data['email'] = this.email;
    data['author'] = this.author;
    return data;
  }
}

class Src {
  late String original;
  late String thumbnail;

  Src({required this.original, required this.thumbnail});

  Src.fromJson(Map<String, dynamic> json) {
    original = json['original'];
    thumbnail = json['thumbnail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['original'] = this.original;
    data['thumbnail'] = this.thumbnail;
    return data;
  }
}

Color fromRGB(String color) {
  RegExp rgb = RegExp(r"^rgb\(([0-9.]+),\s*([0-9.]+),\s*([0-9]+)\)$");
  final matches = rgb.firstMatch(color);
  final r = matches!.group(1);
  final g = matches.group(2);
  final b = matches.group(3);
  return Color.fromARGB(
    255,
    r == null ? 0 : int.parse(r),
    g == null ? 0 : int.parse(g),
    b == null ? 0 : int.parse(b),
  );
}

class Tag{
  late String tag;
  late WallpaperData data;
  Tag({required String tag, required WallpaperData data}){
    this.tag = tag;
    this.data = data;
  }
}