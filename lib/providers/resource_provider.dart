import 'package:flutter/foundation.dart';

import 'package:filebrowser/models/models.dart';

import 'package:filebrowser/services/base/resource_service.dart';
import 'package:filebrowser/services/impl/resource_service_impl.dart';

import 'package:filebrowser/utils/logger.dart';

class ResourceProvider with ChangeNotifier {
  static const Logger _logger = Logger("AuthProvider");

  /// current folder - initialially will be /
  Folder _currentFolder = Folder(
    modified: DateTime(1970),
    name: '',
    path: '',
    size: 0,
  );

  /// current content of the folder
  FolderContent _currentLevelContent = FolderContent();
  bool _failLoadContent = false;

  final ResourceService _resourceService = ResourceServiceImpl();

  void updateToken(Token token) {
    (_resourceService as ResourceServiceImpl).updateToken(token);

    openFolder(_currentFolder);
  }

  Future<void> openFolder(Folder folder) async {
    FolderContent? content = await _resourceService.openFolder(folder);

    if (content == null) {
      _logger.message('Failedto load content');
      _failLoadContent = true;
      notifyListeners();
      return;
    }

    content.path = folder.path;
    _currentFolder = folder.copyWith();

    _currentLevelContent = content;
    _failLoadContent = false;

    notifyListeners();
  }

  Folder get folder {
    return _currentFolder;
  }

  FolderContent get content {
    return _currentLevelContent;
  }

  bool get haveFailedLoadContent {
    return _failLoadContent;
  }
}
