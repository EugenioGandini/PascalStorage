import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../models/models.dart';
import '../../utils/logger.dart';
import '../../providers/resource_provider.dart';

import 'dialogs/dialogs.dart';
import 'notifications.dart' as notify;

/// General resource operation (common to both files and folders)
/// are grouped here.
class GeneralOperations {
  final Logger logger;
  final BuildContext context;
  final ResourceProvider resProvider;
  final VoidCallback onReloadContentNeeded;

  GeneralOperations({
    required this.context,
    required this.resProvider,
    required this.logger,
    required this.onReloadContentNeeded,
  });

  Future selectNewName(Resource resource) async {
    Navigator.of(context).pop();

    bool renameSuccess =
        await buildDialogRenameResource(context, resourceToBeRenamed: resource);

    if (!renameSuccess) return;

    if (context.mounted) {
      notify.showRenameResourceSuccess(context);
    }

    onReloadContentNeeded();
  }

  Future deleteRemoteResource(List<Resource> resources) async {
    String message = resources[0].name;
    int numResources = resources.length;

    if (numResources > 1) {
      int numFiles = resources.whereType<ResourceFile>().length;
      int numFolders = resources.whereType<ResourceFolder>().length;

      List<String> messageParts = [];
      if (numFiles > 0) messageParts.add('$numFiles file');
      if (numFolders > 0) messageParts.add('$numFolders cartelle');
      message = messageParts.join('\n');
    }

    var hasConfirmed = await askConfirmation(
      context,
      AppLocalizations.of(context)!.dialogDeleteTitle,
      '${AppLocalizations.of(context)!.dialogDeleteMessage}?',
      titleHeading: const Icon(
        Icons.delete_forever,
        size: 32,
        color: Colors.red,
      ),
      centerChild: Text(
        message,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.headlineSmall,
      ),
    );

    if (!hasConfirmed) return;

    bool success = await resProvider.deleteRemoteResource(resources);

    if (!success) return;

    if (context.mounted) {
      notify.showDeleteResourceSuccess(
        context,
        resource: numResources == 1 ? resources[0] : null,
      );
    }

    onReloadContentNeeded();
  }

  Future moveResource(Resource source, ResourceFolder target) async {
    if (source is ResourceFolder && source == target) {
      logger.message('Dropped folder on the same folder. Skipping.');
      notify.showFolderCannotBeMoved(context);
      return;
    }

    var success = await resProvider.moveFile(source, target);

    if (!success) return;

    if (context.mounted) {
      notify.showMoveResourceSuccess(context);
    }

    onReloadContentNeeded();
  }

  Future shareResource(Resource resouceToShare) async {
    Navigator.of(context).pop();

    bool shareSuccess = await buildDialogNewShare(context, resouceToShare);

    if (!shareSuccess) return;

    if (context.mounted) {
      notify.showShareResourceSuccess(context);
    }
  }

  Future removeShare(Resource resource, List<Share> activeShares) async {
    Navigator.of(context).pop();

    bool shareRemoved =
        await buildDialogRemoveShare(context, resource, activeShares);

    if (!shareRemoved) return;

    if (context.mounted) {
      notify.showShareResourceRemoved(context);
    }
  }
}
