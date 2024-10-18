import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';

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

    return Settings(
      host: savedHost ?? '',
    );
  }

  @override
  Future<void> saveSettings(Settings settings) async {
    var settingsBox = await _openBox('settings');

    await settingsBox.put('host', settings.host);
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

    await userBox.deleteAll(['username', 'password']);
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
}
