import 'package:flutter/material.dart';

class Utils {
  static void showSnack(context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(bottom: 700, left: 50, right: 50),
        backgroundColor: Colors.blueGrey,
        content: Text(message)));
  }
}
