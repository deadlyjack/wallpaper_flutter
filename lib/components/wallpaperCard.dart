import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget wallpaperCard({
  required String imageSrc,
  required double height,
  required double width,
  void Function()? onPressed,
}) {
  final src = imageSrc;
  return TextButton(
    style: TextButton.styleFrom(
      padding: EdgeInsets.zero,
      splashFactory: NoSplash.splashFactory,
    ),
    onPressed: onPressed,
    child: Container(
      margin: EdgeInsets.only(bottom: 5),
      height: height,
      width: width,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(src),
          fit: BoxFit.cover,
        ),
      ),
    ),
  );
}
