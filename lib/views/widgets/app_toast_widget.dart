import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

class CustomToasts {
  static bool isToastActive = false;

  static void showSuccessToast({
    String? message = 'Success',
    ToastGravity? toastGravity,
  }) {
    if (isToastActive) return;

    isToastActive = true;
    Fluttertoast.showToast(
      msg: message ?? '',
      toastLength: Toast.LENGTH_SHORT,
      gravity: toastGravity ?? ToastGravity.BOTTOM,
      backgroundColor: Colors.lightGreen,
      textColor: Colors.green[900],
      fontSize: 16.0,
    ).then((_) {
      isToastActive = false;
    });
  }
}