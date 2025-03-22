import 'package:flutter/material.dart';

import '../../utils/app_fonts.dart';

void showCustomSnackBar(BuildContext context, String message) {
  ScaffoldMessengerState scaffoldMessenger = ScaffoldMessenger.of(context);

  scaffoldMessenger.hideCurrentSnackBar();

  final snackBar = SnackBar(
    content: Text(
      message,
      style: AppFonts.bodyFont(),
    ),
    duration: const Duration(seconds: 3),
  );

  scaffoldMessenger.showSnackBar(snackBar);
}