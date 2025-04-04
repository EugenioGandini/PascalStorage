import 'dart:io';
import 'dart:typed_data';

import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart' as path;
import 'package:file_picker/file_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../config/permissions.dart';
import '../../models/models.dart';
import '../../utils/utilities.dart';
import '../../providers/resource_provider.dart';

import 'dialogs/dialogs.dart';
import 'notifications.dart' as notify;

/// Group of file operations.
class FileOperations {
  final Logger logger;
  final BuildContext context;
  final ResourceProvider resProvider;
  final VoidCallback onReloadContentNeeded;

  FileOperations({
    required this.context,
    required this.resProvider,
    required this.logger,
    required this.onReloadContentNeeded,
  });

  Future askSaveFile(List<Resource> resources, Settings settings) async {
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
      AppLocalizations.of(context)!.askDownloadTitle,
      AppLocalizations.of(context)!.askDownloadMessage,
      titleHeading: const Icon(
        Icons.download,
        size: 32,
      ),
      centerChild: Text(
        message,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.headlineSmall,
      ),
    );

    if (!hasConfirmed) return;

    if (!context.mounted) return;
    var customDestination = settings.defaultFolderDownload;

    String? outputFolder = customDestination.isNotEmpty
        ? customDestination
        : await getDownloadFolder();

    if (outputFolder == null) return;

    await saveFile(resources, outputFolder);

    if (numResources == 1 && settings.openFileUponDownload) {
      await OpenFile.open(
        path.join(outputFolder, resources[0].name),
      );
    }
  }

  Future saveFile(List<Resource> remoteResources, String path) async {
    for (var resource in remoteResources) {
      if (resource is! ResourceFile) continue;

      logger.message(
          'Saving remote file ${resource.name} onto this device at path $path');

      await for (final percentage in resProvider.downloadFile(resource, path)) {
        logger.message('Download $percentage %');

        if (percentage == 100) {
          logger.message('Download completed succesfully!!!');

          resProvider.registerOfflineResource(resource, path);

          notify.showDownloadSuccess(context);
        }
      }
    }
  }

  Future selectFileToBeUploaded(ResourceFolder currentRemoteFolder) async {
    if (!await hasStorageAccessPermission()) return;

    logger.message('Selecting file to upload');

    var result = await FilePicker.platform.pickFiles(
      withData: Platform.isWeb,
      allowMultiple: true,
      dialogTitle: context.mounted
          ? AppLocalizations.of(context)!.selectFileToBeUploaded
          : '',
    );

    if (result == null) return;

    for (var file in result.files) {
      PlatformFile filePath = file;

      late Uint8List buffer;
      late String fileFullName;

      if (Platform.isWeb) {
        logger.message(
            'File selected ${filePath.name} ${filePath.bytes!.length} bytes');

        fileFullName = filePath.name;
        buffer = filePath.bytes!;
      } else {
        logger.message('File selected ${filePath.path}');

        var fileToUpload = File(filePath.path!);

        fileFullName = path.basename(fileToUpload.path);
        buffer = await fileToUpload.readAsBytes();
      }

      await uploadFile(currentRemoteFolder, fileFullName, buffer);
    }
  }

  Future uploadFile(
    ResourceFolder remoteFolder,
    String fileFullName,
    Uint8List buffer,
  ) async {
    logger.message(
        'Uploading file $fileFullName to remote folder ${remoteFolder.name}');

    var override = remoteFolder.containsFileWithName(fileFullName);

    await for (var percentage in resProvider.uploadFile(
        fileFullName, buffer, remoteFolder, override)) {
      logger.message('Uploading... $percentage %');

      if (percentage == 100) {
        logger.message('Upload completed successfully !!!');

        notify.showUploadSuccess(context);

        logger.message('Reloading folder content...');

        onReloadContentNeeded();
      }
    }
  }

  Future draggedFiles(
    List<DropItem> filesDropped,
    ResourceFolder currentRemoteFolder,
  ) async {
    for (var fileDropped in filesDropped) {
      var fileToUpload = File(fileDropped.path);
      var fileFullName = path.basename(fileToUpload.path);

      logger.message('File dropped $fileFullName');

      var buffer = await fileToUpload.readAsBytes();

      await uploadFile(currentRemoteFolder, fileFullName, buffer);
    }
  }
}
