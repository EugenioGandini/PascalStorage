import 'dart:typed_data';

import '../../models/models.dart';

abstract class ResourceService {
  Future<FolderContent?> openFolder(RemoteFolder folder);
  Stream<int> downloadFile(RemoteFile file, String dirOutput);
  Stream<int> uploadFile(
      Uint8List bufferFile, String remoteFolderPath, bool override);
  Future<bool> deleteFile(RemoteFile file);
  Future<bool> moveFile(RemoteFile file, String destinationPath);
  Future<bool> createFolder(String folderName, String parentFolderPath);
  Future<bool> moveFolder(RemoteFolder folder, String destinationPath);
  Future<bool> deleteFolder(RemoteFolder folder);
}
