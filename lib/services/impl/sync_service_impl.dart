import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:connectivity_plus/connectivity_plus.dart';

import '../base/resource_service.dart';
import '../base/local_storage_service.dart';
import '../base/sync_service.dart';

import '../../utils/logger.dart';
import '../../models/models.dart';

class SyncServiceImpl extends SyncService {
  static const Logger _logger = Logger("SyncService");

  final LocalStorageService localStorageService;
  final ResourceService resourceService;
  final List<ConnectivityResult> _acceptedConnections = [
    ConnectivityResult.ethernet,
    ConnectivityResult.mobile,
    ConnectivityResult.wifi,
  ];

  List<ResourceFolder> tmpRemoteFolders = [];

  SyncServiceImpl({
    required this.localStorageService,
    required this.resourceService,
  }) {
    _init();
  }

  @override
  Future syncResources() async {
    var connectivityInfo = await Connectivity().checkConnectivity();
    var isConnected = connectivityInfo
        .any((connectivity) => _acceptedConnections.contains(connectivity));

    if (!isConnected) {
      _logger.message('Skip sync as there are no network connectivities');
      return;
    }

    _logger.message('Fetching offline files...');

    var filesToSync =
        await localStorageService.getOfflineFiles(syncActive: true);

    if (filesToSync.isEmpty) {
      _logger.message('No sync activated');
      return;
    }

    tmpRemoteFolders.clear();

    filesToSync.forEach(_syncFile);
  }

  @override
  Future addOfflineFileToSync({
    required ResourceFile remoteFile,
    required String localPath,
    Sync? sync,
  }) async {
    late DateTime lastModify;
    late int size;

    var filePath = path.join(localPath, remoteFile.name);
    var localFile = File(filePath);

    if (await localFile.exists()) {
      lastModify = await localFile.lastModified();
      size = await localFile.length();
    }

    var newOfflineFile = OfflineFile(
      localCopy: remoteFile.copyWith(
        size: size,
        modified: lastModify.toUtc(),
        path: filePath,
      ),
      remoteCopy: remoteFile,
    );

    int id =
        await localStorageService.saveNewOfflineAvailability(newOfflineFile);

    var currentSync = await localStorageService.getSync();

    var updatedSync = currentSync.copyWith(addId: id);

    await localStorageService.saveSync(updatedSync);

    _logger.message('Offline file saved and added to default sync');
  }

  @override
  Future updateOfflineFileSync(
    OfflineFile updatedOfflineFile, {
    Sync? sync,
  }) async {
    await localStorageService.updateOfflineFile(updatedOfflineFile);

    var activatedSync = updatedOfflineFile.synchronize;

    _logger.message(
        'Offline file synchronization ${activatedSync ? 'activated' : 'de-activated'}');
  }

  @override
  Future removeOfflineFileFromSync(
    List<OfflineFile> offlineFiles, {
    Sync? sync,
  }) async {
    for (var offlineFile in offlineFiles) {
      _logger.message('deleting offline file... ${offlineFile.localCopy.path}');

      await localStorageService.removeOfflineFile(offlineFile);
    }

    var currentSync = await localStorageService.getSync();

    var updatedSync = currentSync.copyWith(
      withoutIds: offlineFiles.map((file) => file.id!).toList(),
    );

    await localStorageService.saveSync(updatedSync);

    _logger.message('Offline file removed and default sync updated');
  }

  Future _init() async {
    try {
      await localStorageService.getSync();
    } catch (error) {
      _logger.message('Creating default sync');

      await localStorageService.saveSync(Sync.defaultSync());

      _logger.message('Default sync saved');
    }
  }

  Future _syncFile(OfflineFile file) async {
    _logger.message('Sync check: file ${file.remoteCopy.name}');

    ResourceFile? currentLocalFile;

    var localFile = File(file.localCopy.path);
    if (await localFile.exists()) {
      var lastModify = await localFile.lastModified();
      var size = await localFile.length();

      currentLocalFile = file.localCopy.copyWith(
        modified: lastModify.toUtc(),
        size: size,
      );
    }

    ResourceFile? currentRemoteFile;

    bool shouldFetch = false;
    ResourceFolder remoteParentFolder = tmpRemoteFolders.firstWhere((folder) {
      return folder.path == file.remoteCopy.parentPath;
    }, orElse: () {
      var tmpRemoteFolder = ResourceFolder(
        path: file.remoteCopy.parentPath,
        name: '',
        size: 0,
        modified: DateTime.now(),
      );

      shouldFetch = true;

      return tmpRemoteFolder;
    });

    if (shouldFetch) {
      var loadedRemoteParentFolder =
          await resourceService.openFolder(remoteParentFolder.path);

      if (loadedRemoteParentFolder == null) {
        _logger.message('Failed to fetch remote folder. Skip sync');
        return;
      }

      tmpRemoteFolders.add(loadedRemoteParentFolder);
      remoteParentFolder = loadedRemoteParentFolder;
    }

    var remoteFile = remoteParentFolder.getFileWithName(file.remoteCopy.name);

    if (remoteFile != null) {
      currentRemoteFile = file.remoteCopy.copyWith(
        modified: remoteFile.modified,
        size: remoteFile.size,
      );
    }

    var fileSync = ResourceFileSync(
      dbFile: file,
      localFile: currentLocalFile,
      remoteFile: currentRemoteFile,
    );

    _logger.message(fileSync.toString());
    _logger.message(
        'Location: ${fileSync.location}, action to perform ${fileSync.action}');

    switch (fileSync.action) {
      case SyncAction.upload:
        await _uploadNewerLocal(file, localFile);
        break;
      case SyncAction.download:
        await _downloadNewerRemote(file, currentRemoteFile!);
        break;
      case SyncAction.ask:
        // TODO listener to notify the user
        break;
      default:
        break;
    }
  }

  Future _downloadNewerRemote(
      OfflineFile file, ResourceFile newerRemote) async {
    try {
      await resourceService
          .downloadFile(newerRemote, file.localCopy.parentPathLocaleAware)
          .drain();
    } catch (error) {
      _logger.message('Failed to download newer remote file');
      return;
    }

    var localFile = File(file.localCopy.path);
    var lastModify = await localFile.lastModified();
    var size = await localFile.length();

    var updatedOfflineFile = file.copyWith(
      localCopy: file.localCopy.copyWith(
        modified: lastModify.toUtc(),
        size: size,
      ),
      remoteCopy: newerRemote,
    );

    await localStorageService.updateOfflineFile(updatedOfflineFile);

    _logger.message('Updated offline file ${updatedOfflineFile.toString()}');
  }

  Future _uploadNewerLocal(OfflineFile file, File newerLocale) async {
    var remoteFolder = file.remoteCopy.parentPath;
    var remoteFileName = file.remoteCopy.name;

    try {
      var bufferFile = await newerLocale.readAsBytes();
      resourceService
          .uploadFile(
            bufferFile,
            path.join(remoteFolder, remoteFileName),
            true,
          )
          .drain();
    } catch (error) {
      _logger.message('Failed to upload newer local file');
      return;
    }

    _logger.message('Uploaded newer version of file $remoteFileName');

    var lastModify = await newerLocale.lastModified();
    var size = await newerLocale.length();

    ResourceFile? newerRemote;
    var finishSave = false;

    while (!finishSave) {
      await Future.delayed(const Duration(seconds: 1));

      var newerRemoteFolder = await resourceService.openFolder(remoteFolder);

      if (newerRemoteFolder == null) continue;
      newerRemote = newerRemoteFolder.getFileWithName(file.remoteCopy.name);

      if (newerRemote == null) continue;
      finishSave = newerRemote.size == size;
    }

    var updatedOfflineFile = file.copyWith(
      remoteCopy: newerRemote,
      localCopy: file.localCopy.copyWith(
        modified: lastModify.toUtc(),
        size: size,
      ),
    );

    await localStorageService.updateOfflineFile(updatedOfflineFile);

    _logger.message('Updated offline file ${updatedOfflineFile.toString()}');
  }
}
