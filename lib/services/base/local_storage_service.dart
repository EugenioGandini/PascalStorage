import '../../models/models.dart';

abstract class LocalStorageService {
  Future saveSettings(Settings settings);
  Future<Settings> loadSettings();
  Future saveCredentials(User userCredentials);
  Future deleteCredentials();
  Future<User?> getSavedCredentials();
  Future saveLoginSuccess();
  Future<bool> wasLoggedInSuccessfully();
  Future<int> saveNewOfflineAvailability(OfflineFile offlineFile);
  Future updateOfflineFile(OfflineFile offlineFile);
  Future<List<OfflineFile>> getOfflineFiles({
    List<int>? idsOnly,
    bool? syncActive,
  });
  Future removeOfflineFile(OfflineFile offlineFile);
  Future saveSync(Sync sync);
  Future<Sync> getSync();
}
