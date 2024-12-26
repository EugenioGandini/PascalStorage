import 'package:flutter/foundation.dart';

import '../../models/models.dart';

import '../services/base/resource_service.dart';
import '../services/impl/resource_service_http_impl.dart';

import '../../utils/logger.dart';

class ResourceProvider with ChangeNotifier {
  static const Logger _logger = Logger("ResourceProvider");

  bool _selectModeEnable = false;
  List<RemoteFile> _selectedFiles = [];
  List<RemoteFolder> _selectedFolders = [];

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

  bool get isSelectModeActive {
    return _selectModeEnable;
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

  void setSelectedRemoteResource(
      List<RemoteFile> selectedFiles, List<RemoteFolder> selectedFolder) {
    _selectedFiles = selectedFiles;
    _selectedFolders = selectedFolder;
    _selectModeEnable = true;

    notifyListeners();
  }

  void updateSelectMode(bool enable) {
    _selectModeEnable = enable;
    notifyListeners();
  }

  void toggleSelectedFileResource(RemoteFile selectedFile) {
    if (_selectedFiles.contains(selectedFile)) {
      _selectedFiles.remove(selectedFile);
    } else {
      _selectedFiles.add(selectedFile);
    }

    _selectModeEnable = true;

    notifyListeners();
  }

  void toggleSelectedFolderResource(RemoteFolder selectedFolder) {
    if (_selectedFolders.contains(selectedFolder)) {
      _selectedFolders.remove(selectedFolder);
    } else {
      _selectedFolders.add(selectedFolder);
    }

    _selectModeEnable = true;

    notifyListeners();
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

  Future<bool> createFolder(RemoteFolder folder) async {
    _logger.message('creating remote folder... ${folder.path}');

    return _resourceService.createFolder(folder.name, folder.path);
  }

  Future<bool> renameFolder(RemoteFolder folder, String newName) async {
    _logger.message('renaming remote folder... ${folder.path} into $newName');

    String newPath = "${folder.parentPath}/$newName";

    return _resourceService.moveFolder(folder, newPath);
  }

  Future<bool> deleteFolder(RemoteFolder folder) async {
    _logger.message('deleting remote folder... ${folder.path}');

    return _resourceService.deleteFolder(folder);
  }
}
