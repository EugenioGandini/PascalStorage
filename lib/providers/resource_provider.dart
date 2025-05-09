import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../models/models.dart';

import '../services/base/local_storage_service.dart';
import '../services/impl/local_storage_service_hive_impl.dart';
import '../services/base/resource_service.dart';
import '../services/impl/resource_service_http_impl.dart';
import '../services/base/sync_service.dart';
import '../services/impl/sync_service_impl.dart';

import '../../utils/logger.dart';

class ResourceProvider with ChangeNotifier {
  static const Logger _logger = Logger("ResourceProvider");

  final ResourceService _resourceService = ResourceServiceHttpImpl();
  final LocalStorageService _localService = LocalStorageServiceHiveImpl();
  late SyncService _syncService;

  bool _deleteOfflineResourceAtLogout = false;
  Timer? _periodicSync;
  Duration _runSyncEvery = Duration.zero;

  ResourceProvider(Settings settings) {
    _syncService = SyncServiceImpl(
      localStorageService: _localService,
      resourceService: _resourceService,
    );

    updateSettings(settings);
  }

  ResourceFolder get homeFolder {
    return ResourceFolder(
      path: '/',
      name: 'Home',
      size: 0,
      modified: DateTime.now(),
    );
  }

  void updateSettings(Settings newSettings) {
    if (_resourceService is ResourceServiceHttpImpl) {
      _resourceService.setHost(newSettings.host);
    }

    if (_runSyncEvery != newSettings.periodicSync) {
      _runSyncEvery = newSettings.periodicSync;
    }

    _deleteOfflineResourceAtLogout = newSettings.deleteOfflineResourceAtLogout;
  }

  void updateLogin(Token token) {
    if (_resourceService is ResourceServiceHttpImpl) {
      _resourceService.updateToken(token);
    }

    _updateTimerSync();
  }

  void _updateTimerSync() {
    _periodicSync?.cancel();
    _logger.message('Cancelled timer sync. Frequency is now $_runSyncEvery');

    if (_runSyncEvery != Duration.zero) {
      _periodicSync = Timer.periodic(_runSyncEvery, (timer) {
        syncFiles();
      });
    }
  }

  Future removeLogout() async {
    if (_resourceService is ResourceServiceHttpImpl) {
      _resourceService.updateToken(null);
    }

    if (_deleteOfflineResourceAtLogout) {
      var defaultSync = await _localService.getSync();
      for (var offlineFile in defaultSync.offlineFiles) {
        await _localService.removeOfflineFile(offlineFile);
      }
    }

    _periodicSync?.cancel();
  }

  Future<ResourceFolder?> loadHomeFolder() async {
    return openFolder(homeFolder);
  }

  Future<ResourceFolder?> openFolder(ResourceFolder folder) async {
    _logger.message('loading folder... ${folder.name}');

    ResourceFolder? content = await _resourceService.openFolder(folder.path);

    if (content == null) {
      _logger.message('Failed to load content');
      return null;
    }

    return content;
  }

  Stream<int> downloadFile(ResourceFile file, String dirOutput) {
    _logger.message('downloading file... ${file.name} to $dirOutput');

    var streamDownload = _resourceService.downloadFile(file, dirOutput);

    return streamDownload;
  }

  Future registerOfflineResource(
      ResourceFile remoteFile, String localPath) async {
    await _syncService.addOfflineFileToSync(
      remoteFile: remoteFile,
      localPath: localPath,
    );
  }

  Future updateOfflineFiles(OfflineFile updatedOfflineFile) async {
    await _syncService.updateOfflineFileSync(updatedOfflineFile);
    notifyListeners();
  }

  Future<Sync> loadSync({int? id}) async {
    return await _localService.getSync();
  }

  Stream<int> uploadFile(
    String fileFullName,
    Uint8List bufferFile,
    ResourceFolder remoteFolder,
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
      if (resource is ResourceFile) {
        _logger.message('deleting remote file... ${resource.path}');

        if (!await _resourceService.deleteFile(resource)) {
          return false;
        }
      }
      if (resource is ResourceFolder) {
        _logger.message('deleting remote folder... ${resource.path}');

        if (!await _resourceService.deleteFolder(resource)) {
          return false;
        }
      }
    }

    return true;
  }

  Future<bool> deleteOfflineFiles(List<OfflineFile> offlineFiles) async {
    await _syncService.removeOfflineFileFromSync(offlineFiles);

    notifyListeners();

    return true;
  }

  Future syncFiles() async {
    await _syncService.syncResources();
  }

  Future<bool> moveFile(
      Resource resource, ResourceFolder destinationFolder) async {
    _logger.message(
        'moving remote resource... ${resource.path} to ${destinationFolder.path}');

    return await _resourceService.moveFile(
        resource, '${destinationFolder.path}/${resource.name}');
  }

  Future<bool> renameResource(Resource resource, String newName) async {
    String newPath = "${resource.parentPath}/$newName";

    if (resource is ResourceFile) {
      _logger.message('renaming remote file... ${resource.path} into $newName');

      return _resourceService.moveFile(resource, newPath);
    }
    if (resource is ResourceFolder) {
      _logger
          .message('renaming remote folder... ${resource.path} into $newName');

      return _resourceService.moveFolder(resource, newPath);
    }
    return false;
  }

  Future<bool> createFolder(ResourceFolder folder) async {
    _logger.message('creating remote folder... ${folder.path}');

    return _resourceService.createFolder(folder.name, folder.path);
  }

  Future<List<Share>?> getShares({Resource? resource}) async {
    if (resource != null) {
      _logger.message('loading shares for resource... ${resource.name}');
      return await _resourceService.getShareForResource(resource);
    }

    _logger.message('loading all the shares...');
    return await _resourceService.getAllShare();
  }

  Future<Share?> createNewShare(
      Resource forResource, ShareConfiguration configuration) async {
    _logger.message('Creating a new share for resource ${forResource.name}');
    return await _resourceService.createNewShareForResource(
        forResource, configuration);
  }

  Future<bool> deleteShare(Share share) async {
    _logger.message(
        'Deleting share hash ${share.hash} for resource ${share.path}');
    return await _resourceService.deleteShare(share);
  }
}
