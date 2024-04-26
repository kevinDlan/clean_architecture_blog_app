import 'package:flutter/material.dart';

void showSnackbar(BuildContext context, String content, Color backgroundColor) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(
      backgroundColor: backgroundColor,
      content: Text(
        content,
        style:
            const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    ));
}
