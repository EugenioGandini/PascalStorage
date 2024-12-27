import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Asks for a confirmation to the user to do something with
/// customizable:
/// - title
/// - message
///
/// The return will be a Future of bool
Future<bool> askConfirmation(
  BuildContext context,
  String title,
  String message, {
  Widget? titleHeading,
  Widget? centerChild,
}) async {
  var result = await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Row(
          children: [
            if (titleHeading != null) ...[
              titleHeading,
              const SizedBox(width: 8)
            ],
            Text(title),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            if (centerChild != null) ...[
              const SizedBox(height: 16),
              centerChild,
            ],
          ],
        ),
        titlePadding: const EdgeInsets.all(20),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
        actionsPadding: const EdgeInsets.all(20),
        shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Text(AppLocalizations.of(context)!.yes),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text(AppLocalizations.of(context)!.no),
                ),
              )
            ],
          )
        ],
      );
    },
  );

  if (result is bool && result) return true;
  return false;
}
