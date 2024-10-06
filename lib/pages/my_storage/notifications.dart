import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void showDownloadSuccess(BuildContext context) {
  var snackbarError = SnackBar(
    content: Row(
      children: [
        const Icon(Icons.download_rounded, color: Colors.white),
        const SizedBox(width: 16),
        Text(AppLocalizations.of(context)!.downloadSuccess),
      ],
    ),
    backgroundColor: Colors.green,
  );

  ScaffoldMessenger.of(context).showSnackBar(snackbarError);
}

void showUploadSuccess(BuildContext context) {
  var snackbarError = SnackBar(
    content: Row(
      children: [
        const Icon(Icons.upload, color: Colors.white),
        const SizedBox(width: 16),
        Text(AppLocalizations.of(context)!.uploadSuccess),
      ],
    ),
    backgroundColor: Colors.green,
  );

  ScaffoldMessenger.of(context).showSnackBar(snackbarError);
}
