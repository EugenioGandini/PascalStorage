import 'package:flutter/material.dart';

void showSnackbar(
  BuildContext context,
  Icon icon,
  String text, {
  Color backgroundColor = Colors.green,
}) {
  var snackbarError = SnackBar(
    content: Row(
      children: [
        icon,
        const SizedBox(width: 16),
        Text(text),
      ],
    ),
    backgroundColor: backgroundColor,
  );

  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(snackbarError);
}
