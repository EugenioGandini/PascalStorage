import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path/path.dart' as path;

import '../../utils/platform.dart';
import '../../models/models.dart';

import '../base/local_storage_service.dart';

/// This implementation of the settings service save
/// data in local encrypted storage on the device
/// for reload on future startup
class LocalStorageServiceHiveImpl extends LocalStorageService {
  Future<List<int>> _loadKey() async {
    FlutterSecureStorage storage;

    if (Platform.isAndroid) {
      var androidOptions = const AndroidOptions(
        encryptedSharedPreferences: true,
      );
      storage = FlutterSecureStorage(aOptions: androidOptions);
    } else {
      storage = const FlutterSecureStorage();
    }

    List<int> key = [];
    if (await storage.containsKey(key: 'keySettingsBox')) {
      var base64Key = await storage.read(key: 'keySettingsBox');
      key = base64Decode(base64Key!);
    } else {
      key = Hive.generateSecureKey();
      await storage.write(key: 'keySettingsBox', value: base64Encode(key));
    }

    return key;
  }

  String? get storagePath {
    if (Platform.isWindows) {
      return "${Platform.appDataPath}/cc.eugenioing.pascalstorage/pascalstorage";
    }

    return null;
  }

  Future<Box> _openBox(String boxName) async {
    List<int> key = await _loadKey();

    if (boxName == 'offline_files') {
      return await Hive.openBox<OfflineFile>(
        boxName,
        path: storagePath,
        encryptionCipher: HiveAesCipher(
          key,
        ),
      );
    }

    if (boxName == 'synchronizations') {
      return await Hive.openBox<Sync>(
        boxName,
        path: storagePath,
        encryptionCipher: HiveAesCipher(
          key,
        ),
      );
    }

    return await Hive.openBox<String>(
      boxName,
      path: storagePath,
      encryptionCipher: HiveAesCipher(
        key,
      ),
    );
  }

  @override
  Future<Settings> loadSettings() async {
    var settingsBox = await _openBox('settings');

    String? savedHost = settingsBox.get('host');
    String? defaultFolderDownload = settingsBox.get('defaultFolderDownload');
    String? openFileStr = settingsBox.get('openFileUponDownload');
    String? syncAtLoginStr = settingsBox.get('syncAtLogin');
    String? periodicSyncStr = settingsBox.get('periodicSync');

    bool? openFileUponDownload;
    if (openFileStr != null) {
      openFileUponDownload = bool.parse(openFileStr);
    }

    bool? syncAtLogin;
    if (syncAtLoginStr != null) {
      syncAtLogin = bool.parse(syncAtLoginStr);
    }

    Duration? periodicSync;
    if (periodicSyncStr != null) {
      periodicSync = Duration(seconds: int.parse(periodicSyncStr));
    }

    return Settings(
      host: savedHost ?? '',
      defaultFolderDownload: defaultFolderDownload ?? '',
      openFileUponDownload: openFileUponDownload ?? true,
      syncAtLogin: syncAtLogin ?? true,
      periodicSync: periodicSync ?? Duration.zero,
    );
  }

  @override
  Future<void> saveSettings(Settings settings) async {
    var settingsBox = await _openBox('settings');

    await settingsBox.put('host', settings.host);
    await settingsBox.put(
        'defaultFolderDownload', settings.defaultFolderDownload);
    await settingsBox.put(
        'openFileUponDownload', settings.openFileUponDownload.toString());
    await settingsBox.put('syncAtLogin', settings.syncAtLogin.toString());
    await settingsBox.put(
        'periodicSync', settings.periodicSync.inSeconds.toString());
  }

  @override
  Future<void> saveLoginSuccess() async {
    var userBox = await _openBox('user');

    await userBox.put('logged_in_successfully', 'true');
  }

  @override
  Future<bool> wasLoggedInSuccessfully() async {
    var userBox = await _openBox('user');

    return userBox.get('logged_in_successfully', defaultValue: 'false') ==
        'true';
  }

  @override
  Future saveCredentials(User userCredentials) async {
    var userBox = await _openBox('user');

    await userBox.put('username', userCredentials.username);
    await userBox.put('password', userCredentials.password);
  }

  @override
  Future deleteCredentials() async {
    var userBox = await _openBox('user');

    await userBox.deleteAll(['username', 'password', 'logged_in_successfully']);
  }

  @override
  Future<User?> getSavedCredentials() async {
    var userBox = await _openBox('user');

    if (!userBox.containsKey('username')) return null;

    return User(
      username: userBox.get('username'),
      password: userBox.get('password'),
    );
  }

  @override
  Future<int> saveNewOfflineAvailability(OfflineFile offlineFile) async {
    var offlineFileBox = await _openBox('offline_files');

    return await offlineFileBox.add(offlineFile);
  }

  @override
  Future updateOfflineFile(OfflineFile offlineFile) async {
    var offlineFileBox = await _openBox('offline_files');

    await offlineFileBox.put(offlineFile.id, offlineFile);
  }

  @override
  Future<List<OfflineFile>> getOfflineFiles({
    List<int>? idsOnly,
    bool? syncActive,
  }) async {
    var offlineFileBox = await _openBox('offline_files');

    if (idsOnly != null) {
      var offlineFilesWithIds = idsOnly
          .where((id) => offlineFileBox.containsKey(id))
          .map(
            (id) => (offlineFileBox.get(id) as OfflineFile).copyWith(id: id),
          )
          .toList();

      return offlineFilesWithIds;
    }

    var mapOfflineFiles = (offlineFileBox.toMap() as Map<dynamic, OfflineFile>);

    var allOfflineFiles = mapOfflineFiles.entries.map((entry) {
      return entry.value.copyWith(id: entry.key);
    }).toList();

    if (syncActive != null) {
      return allOfflineFiles
          .where((file) => file.synchronize == syncActive)
          .toList();
    }

    return allOfflineFiles;
  }

  @override
  Future removeOfflineFile(OfflineFile offlineFile) async {
    var offlineFileBox = await _openBox('offline_files');

    var localCopy = offlineFile.localCopy;

    var file = File(path.join(localCopy.path, localCopy.name));

    try {
      if (await file.exists()) await file.delete();
      await offlineFileBox.delete(offlineFile.id);
    } catch (error) {}
  }

  @override
  Future saveSync(Sync sync) async {
    var syncBox = await _openBox('synchronizations');

    if (syncBox.containsKey(sync.id)) {
      syncBox.put(sync.id, sync);
    } else {
      syncBox.add(sync);
    }
  }

  @override
  Future<Sync> getSync() async {
    var syncBox = await _openBox('synchronizations');

    Sync? sync = syncBox.get(0, defaultValue: null);

    if (sync == null) {
      throw Exception('Sync not found in box');
    }

    sync.offlineFiles = await getOfflineFiles(idsOnly: sync.offlineFileIds);

    return sync;
  }
}
