import 'dart:io';

import 'package:flutter/foundation.dart';

import 'package:filebrowser/models/models.dart';

import 'package:filebrowser/services/base/resource_service.dart';
import 'package:filebrowser/services/impl/resource_service_http_impl.dart';

import 'package:filebrowser/utils/logger.dart';
import 'package:path/path.dart';

class ResourceProvider with ChangeNotifier {
  static const Logger _logger = Logger("ResourceProvider");

  final ResourceService _resourceService = ResourceServiceHttpImpl();

  ResourceProvider(Settings settings) {
    updateSettings(settings);
  }

  RemoteFolder get homeFolder {
    return RemoteFolder(
      path: '',
      name: 'Home',
      size: 0,
      modified: DateTime.now(),
    );
  }

  void updateSettings(Settings newSettings) {
    if (_resourceService is ResourceServiceHttpImpl) {
      _resourceService.setHost(newSettings.host);
    }
  }

  void updateToken(Token token) {
    if (_resourceService is ResourceServiceHttpImpl) {
      _resourceService.updateToken(token);
    }
  }

  void removeToken() {
    if (_resourceService is ResourceServiceHttpImpl) {
      _resourceService.updateToken(null);
    }
  }

  Future<FolderContent?> loadHomeFolder() async {
    return openFolder(homeFolder);
  }

  Future<FolderContent?> openFolder(RemoteFolder folder) async {
    _logger.message('loading folder... ${folder.name}');

    FolderContent? content = await _resourceService.openFolder(folder);

    if (content == null) {
      _logger.message('Failed to load content');
      return null;
    }

    return content;
  }

  Stream<int> downloadFile(RemoteFile file, String dirOutput) {
    _logger.message('downloading file... ${file.name} to $dirOutput');

    return _resourceService.downloadFile(file, dirOutput);
  }

  Stream<int> uploadFile(
    File localFilePath,
    RemoteFolder remoteFolder,
    bool override,
  ) {
    var fileName = basename(localFilePath.path);

    _logger.message('uploading file... $fileName to ${remoteFolder.path}');

    return _resourceService.uploadFile(
      localFilePath.path,
      "${remoteFolder.path}/$fileName",
      override,
    );
  }

  Future<bool> deleteFile(RemoteFile file) async {
    _logger.message('deleting remote file... ${file.path}');

    return _resourceService.deleteFile(file);
  }

  Future<bool> moveFile(RemoteFile file, String destinationPath) async {
    _logger.message('moving remote file... ${file.path} to $destinationPath');

    return _resourceService.moveFile(file, destinationPath);
  }

  Future<bool> renameFile(RemoteFile file, String newName) async {
    _logger.message('renaming remote file... ${file.path} into $newName');

    String newPath = "${file.parentPath}/$newName";

    return _resourceService.moveFile(file, newPath);
  }
}
