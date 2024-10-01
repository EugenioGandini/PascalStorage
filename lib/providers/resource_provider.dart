import 'package:flutter/foundation.dart';

import 'package:filebrowser/models/models.dart';

import 'package:filebrowser/services/base/resource_service.dart';
import 'package:filebrowser/services/impl/resource_service_http_impl.dart';

import 'package:filebrowser/utils/logger.dart';

class ResourceProvider with ChangeNotifier {
  static const Logger _logger = Logger("ResourceProvider");

  final ResourceService _resourceService = ResourceServiceHttpImpl();

  ResourceProvider(Settings settings) {
    updateSettings(settings);
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

  Future<FolderContent?> loadHomeFolder() async {
    return openFolder(RemoteFolder(
      path: '',
      name: 'Home',
      size: 0,
      modified: DateTime.now(),
    ));
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
}
