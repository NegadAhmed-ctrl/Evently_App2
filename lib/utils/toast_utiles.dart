import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';

class ToastUtiles {
  static Future<bool?> toastMsg({
    required String msg,
    required Color backgroundColor,
    required Color textColor,
    ToastGravity gravity = ToastGravity.CENTER,
  }) {
    return Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: gravity,
      timeInSecForIosWeb: 1,
      backgroundColor: backgroundColor,
      textColor: textColor,
      fontSize: 16.0,
    );
  }
}
