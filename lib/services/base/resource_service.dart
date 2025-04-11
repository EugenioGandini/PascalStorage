import 'dart:typed_data';

import '../../models/models.dart';

abstract class ResourceService {
  Future<ResourceFolder?> openFolder(String path);
  Stream<int> downloadFile(ResourceFile file, String dirOutput);
  Stream<int> uploadFile(
      Uint8List bufferFile, String remoteFolderPath, bool override);
  Future<bool> deleteFile(ResourceFile file);
  Future<bool> moveFile(Resource resource, String destinationPath);
  Future<bool> createFolder(String folderName, String parentFolderPath);
  Future<bool> moveFolder(ResourceFolder folder, String destinationPath);
  Future<bool> deleteFolder(ResourceFolder folder);
  Future<List<Share>?> getAllShare();
  Future<List<Share>?> getShareForResource(Resource resource);
  Future<Share?> createNewShareForResource(Resource resource);
  Future<bool> deleteShare(Share sharing);
}
