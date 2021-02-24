import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

extension ViewUtils on BuildContext {
  void showSnackBarError(
    String message, {
    VoidCallback onVisible,
  }) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  void showSnackBarSuccess(String message, [VoidCallback onVisible]) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.blue,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  void showSnackBarNormal(String message, [VoidCallback onVisible]) {
    Scaffold.of(this).showSnackBar(SnackBar(
      content: Text(message, textAlign: TextAlign.center),
      duration: Duration(seconds: 3),
      behavior: SnackBarBehavior.floating,
      onVisible: onVisible,
    ));
  }
}
