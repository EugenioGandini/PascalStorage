import 'package:flutter/foundation.dart';

import '../../models/models.dart';

import '../services/base/resource_service.dart';
import '../services/impl/resource_service_http_impl.dart';

import '../../utils/logger.dart';

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
    String fileFullName,
    Uint8List bufferFile,
    RemoteFolder remoteFolder,
    bool override,
  ) {
    _logger.message('uploading file... $fileFullName to ${remoteFolder.path}');

    return _resourceService.uploadFile(
      bufferFile,
      "${remoteFolder.path}/$fileFullName",
      override,
    );
  }

  Future<bool> deleteRemoteResource(List<Resource> resources) async {
    for (var resource in resources) {
      if (resource is RemoteFile) {
        _logger.message('deleting remote file... ${resource.path}');

        if (!await _resourceService.deleteFile(resource)) {
          return false;
        }
      }
      if (resource is RemoteFolder) {
        _logger.message('deleting remote folder... ${resource.path}');

        if (!await _resourceService.deleteFolder(resource)) {
          return false;
        }
      }
    }

    return true;
  }

  Future<bool> moveFile(RemoteFile file, String destinationPath) async {
    _logger.message('moving remote file... ${file.path} to $destinationPath');

    return _resourceService.moveFile(file, destinationPath);
  }

  Future<bool> renameResource(Resource resource, String newName) async {
    String newPath = "${resource.parentPath}/$newName";

    if (resource is RemoteFile) {
      _logger.message('renaming remote file... ${resource.path} into $newName');

      return _resourceService.moveFile(resource, newPath);
    }
    if (resource is RemoteFolder) {
      _logger
          .message('renaming remote folder... ${resource.path} into $newName');

      return _resourceService.moveFolder(resource, newPath);
    }
    return false;
  }

  Future<bool> createFolder(RemoteFolder folder) async {
    _logger.message('creating remote folder... ${folder.path}');

    return _resourceService.createFolder(folder.name, folder.path);
  }
}
