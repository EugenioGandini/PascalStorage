import 'package:flutter/foundation.dart';

import '../services/base/local_storage_service.dart';
import '../services/impl/local_storage_service_hive_impl.dart';

import '../../models/models.dart';
import '../../utils/logger.dart';

class SettingsProvider with ChangeNotifier {
  static const Logger _logger = Logger("SettingsProvider");

  Settings _settings = const Settings();
  final LocalStorageService _settingsService = LocalStorageServiceHiveImpl();

  Settings get settings {
    return _settings;
  }

  Future<void> loadSavedSettings() async {
    _logger.message('Loading settings');

    _settings = await _settingsService.loadSettings();
  }

  Future<void> saveHost(String newHost) async {
    _settings = _settings.copyWith(host: newHost);

    await _settingsService.saveSettings(_settings);

    _logger.message('Settings [HOST] saved');

    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<void> changeDefaultFolderDownload(String folderPath) async {
    _settings = _settings.copyWith(defaultFolderDownload: folderPath);

    await _settingsService.saveSettings(_settings);

    _logger.message('Settings [DOWNLOAD FOLDER] saved');

    notifyListeners();
  }

  Future<void> changeOpenFileUponDownload(bool openFileUponDownload) async {
    _settings = _settings.copyWith(openFileUponDownload: openFileUponDownload);

    await _settingsService.saveSettings(_settings);

    _logger.message('Settings [OPEN FILE UPON DOWNLOAD] saved');

    notifyListeners();
  }

  Future<void> changeSyncAtLogin(bool syncAtLogin) async {
    _settings = _settings.copyWith(syncAtLogin: syncAtLogin);

    await _settingsService.saveSettings(_settings);

    _logger.message('Settings [SYNC AT LOGIN] saved');

    notifyListeners();
  }

  Future<void> changeSyncPeriod(Duration every) async {
    _settings = _settings.copyWith(periodicSync: every);

    await _settingsService.saveSettings(_settings);

    _logger.message('Settings [SYNC PERIOD] saved');

    notifyListeners();
  }

  Future<void> deleteOfflineResourceAtLogout(bool remove) async {
    _settings = _settings.copyWith(deleteOfflineResourceAtLogout: remove);

    await _settingsService.saveSettings(_settings);

    _logger.message('Settings [REMOVE OFFLINE RESOURCE AT LOGOUT] saved');

    notifyListeners();
  }
}
