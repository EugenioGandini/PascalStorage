import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../utils/notification_utils.dart';
import '../../models/models.dart';

void showDownloadSuccess(BuildContext context) {
  showSnackbar(
    context,
    const Icon(Icons.download_rounded, color: Colors.white),
    AppLocalizations.of(context)!.downloadSuccess,
  );
}

void showUploadSuccess(BuildContext context) {
  showSnackbar(
    context,
    const Icon(Icons.upload, color: Colors.white),
    AppLocalizations.of(context)!.uploadSuccess,
  );
}

void showDeleteResourceSuccess(
  BuildContext context, {
  Resource? resource,
}) {
  String message = AppLocalizations.of(context)!.deleteSuccess;

  if (resource is RemoteFile) {
    message = AppLocalizations.of(context)!.deleteFileSuccess;
  }
  if (resource is RemoteFolder) {
    message = AppLocalizations.of(context)!.deleteFolderSuccess;
  }

  showSnackbar(
    context,
    const Icon(Icons.delete_forever_rounded, color: Colors.white),
    message,
  );
}

void showRenameResourceSuccess(BuildContext context) {
  showSnackbar(
    context,
    const Icon(Icons.text_fields, color: Colors.white),
    AppLocalizations.of(context)!.renameResourceSuccess,
  );
}

void showNewResourceCreatedSuccess(BuildContext context) {
  showSnackbar(
    context,
    const Icon(Icons.text_fields, color: Colors.white),
    AppLocalizations.of(context)!.newResourceCreatedSuccess,
  );
}
