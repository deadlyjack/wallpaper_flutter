import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

Widget card(BuildContext context, int index,
    {ImageProvider? image, required String label, void Function()? onPressed}) {
  const MARGIN = 10.0;
  final size = MediaQuery.of(context).size;
  final screenWidth = (size.width > 400 ? 400 : size.width);
  final width = (screenWidth - (MARGIN * 3)) / 2;
  final height = width * 1.5;

  var margin = EdgeInsets.fromLTRB(MARGIN, MARGIN, 0, 0);
  if (index % 2 == 0) {
    margin = EdgeInsets.fromLTRB(0, 0, 0, 0);
  }
  return TextButton(
    style: TextButton.styleFrom(
      padding: EdgeInsets.zero,
      splashFactory: NoSplash.splashFactory,
    ),
    onPressed: onPressed != null ? onPressed : () {},
    child: Container(
      margin: margin,
      child: SizedBox(
        width: width,
        height: height,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Container(
            decoration: BoxDecoration(
              image: (image != null)
                  ? DecorationImage(
                      image: image,
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(child: Container()),
                cardTitle(label),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

Container cardTitle(String label) {
  return Container(
    height: 60.0,
    child: Center(
      child: Text(
        label,
        style: const TextStyle(
          color: const Color(0xffffffff),
        ),
      ),
    ),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          const Color(0x11000000),
          const Color(0x99000000),
          const Color(0xdd000000),
          const Color(0xff000000),
        ],
      ),
    ),
  );
}
