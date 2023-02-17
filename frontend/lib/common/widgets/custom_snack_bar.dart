import 'package:flutter/material.dart';

enum SnackBarType { info, error, success }

void showSnackBar(BuildContext context, String message, SnackBarType type) {
  Color? snackBarColor;
  switch (type) {
    case SnackBarType.info:
      snackBarColor = const SnackBarThemeData().backgroundColor;
      break;
    case SnackBarType.error:
      snackBarColor = Colors.red;
      break;
    case SnackBarType.success:
      snackBarColor = Colors.green;
      break;
  }

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: snackBarColor,
      content: Text(message),
      margin: const EdgeInsets.only(bottom: 10),
      behavior: SnackBarBehavior.floating,
    )
  );
}
