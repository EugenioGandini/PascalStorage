import 'package:flutter/foundation.dart';

import 'package:filebrowser/services/base/local_storage_service.dart';
import 'package:filebrowser/services/impl/local_storage_service_hive_impl.dart';

import 'package:filebrowser/models/models.dart';

class SettingsProvider with ChangeNotifier {
  Settings _settings = const Settings();
  final LocalStorageService _settingsService = LocalStorageServiceHiveImpl();

  Settings get settings {
    return _settings;
  }

  Future<void> loadSavedSettings() async {
    _settings = await _settingsService.loadSettings();
  }

  Future<void> saveHost(String newHost) async {
    _settings = _settings.copyWith(host: newHost);

    await _settingsService.saveSettings(_settings);

    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500));
  }
}
