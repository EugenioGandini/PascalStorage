import 'package:permission_handler/permission_handler.dart';

import '../utils/platform.dart';

Future<bool> hasStorageAccessPermission() async {
  if (Platform.isAndroid) {
    var storagePermission = await Permission.manageExternalStorage.status;

    if (storagePermission.isRestricted) {
      storagePermission = await Permission.storage.status;
    }

    if (!storagePermission.isGranted) {
      await Permission.manageExternalStorage.request();
      return false;
    }
  }

  return true;
}
