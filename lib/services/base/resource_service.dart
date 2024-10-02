import 'package:filebrowser/models/models.dart';

abstract class ResourceService {
  Future<FolderContent?> openFolder(RemoteFolder folder);
  Stream<int> downloadFile(RemoteFile file, String dirOutput);
  Stream<int> uploadFile(
      String localFilePath, String remoteFolderPath, bool override);
}
