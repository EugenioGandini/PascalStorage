import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:pascalstorage/config/permissions.dart';
import 'package:pascalstorage/utils/platform.dart';
import 'package:path_provider/path_provider.dart';

Future<String?> chooseOutputFolder() async {
  if (!await hasStorageAccessPermission()) return null;

  var result = await FilePicker.platform.getDirectoryPath();

  if (result == null) return null;

  String directoryPath = result;

  return directoryPath;
}

Future<String?> getDownloadFolder() async {
  if (!await hasStorageAccessPermission()) return null;

  if (Platform.isAndroid) {
    Directory downloadDir =
        Directory('/storage/emulated/0/Download/PascalStorage/');

    if (!await downloadDir.exists()) {
      try {
        return (await downloadDir.create()).path;
      } catch (ignored) {
        /// folder cannot be retrieved. fallback to standard download directory
      }
    } else {
      return downloadDir.path;
    }
  }

  var downloadDirectory = await getDownloadsDirectory();

  if (downloadDirectory == null) return null;
  String outputPath = downloadDirectory.path;

  return outputPath;
}
