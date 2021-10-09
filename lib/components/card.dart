import 'package:flutter/widgets.dart';
import 'package:wallpaper/consts.dart';

Widget card() {
  return SizedBox(
    width: 180.0,
    height: 380.0,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(Consts.demoImage),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(child: Container()),
              cardTitle(),
            ],
          )),
    ),
  );
}

Container cardTitle() {
  return Container(
    height: 60.0,
    child: Center(
      child: Text(
        'Home',
        style: TextStyle(
          color: Color(0xffffffff),
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
