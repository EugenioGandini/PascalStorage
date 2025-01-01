import 'package:flutter/material.dart';

void showSnackbar(BuildContext context, Icon icon, String text) {
  var snackbarError = SnackBar(
    content: Row(
      children: [
        icon,
        const SizedBox(width: 16),
        Text(text),
      ],
    ),
    backgroundColor: Colors.green,
  );

  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(snackbarError);
}
