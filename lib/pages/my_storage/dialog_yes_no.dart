import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<bool> askConfirmation(
    BuildContext context, String title, String message) async {
  var result = await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: Text(AppLocalizations.of(context)!.yes),
          ),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(AppLocalizations.of(context)!.no),
            ),
          )
        ],
      );
    },
  );

  if (result is bool && result) return true;
  return false;
}
