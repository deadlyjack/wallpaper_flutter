import 'package:flutter/material.dart';

void alert(context, {String title = 'alert', required dynamic content}) {
  showDialog(
    context: context,
    builder: (BuildContext buildContext) {
      return AlertDialog(
        title: Text(title.toUpperCase()),
        content: (content is Widget) ? content : Text(content),
      );
    },
  );
}
