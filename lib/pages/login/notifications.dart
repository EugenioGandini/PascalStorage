import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void showSuccessLogin(BuildContext context) {
  var snackbarError = SnackBar(
    content: Row(
      children: [
        const Icon(Icons.check, color: Colors.white),
        const SizedBox(width: 16),
        Text(AppLocalizations.of(context)!.loginSuccess),
      ],
    ),
    backgroundColor: Colors.green,
  );

  ScaffoldMessenger.of(context).showSnackBar(snackbarError);
}

void showErrorLogin(BuildContext context) {
  var snackbarError = SnackBar(
    content: Row(
      children: [
        const Icon(Icons.error, color: Colors.white),
        const SizedBox(width: 16),
        Text(AppLocalizations.of(context)!.loginFailed),
      ],
    ),
    backgroundColor: Colors.red,
  );

  ScaffoldMessenger.of(context).showSnackBar(snackbarError);
}
