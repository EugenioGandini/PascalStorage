import 'package:flutter/material.dart';

import '../../models/models.dart';
import '../../utils/logger.dart';
import '../../providers/resource_provider.dart';

import 'dialogs/dialogs.dart';
import 'notifications.dart' as notify;

/// Folder operation are grouped here.
class FolderOperations {
  final Logger logger;
  final BuildContext context;
  final ResourceProvider resProvider;
  final VoidCallback onReloadContentNeeded;

  FolderOperations({
    required this.context,
    required this.resProvider,
    required this.logger,
    required this.onReloadContentNeeded,
  });

  Future crateNewResource(ResourceFolder currentRemoteFolder) async {
    bool newFolderSuccess =
        await buildDialogNewResource(context, currentRemoteFolder, true);

    if (!newFolderSuccess) return;

    if (context.mounted) {
      notify.showNewResourceCreatedSuccess(context);
    }

    onReloadContentNeeded();
  }
}
