import 'package:filebrowser/models/models.dart';

abstract class LocalStorageService {
  Future saveSettings(Settings settings);
  Future<Settings> loadSettings();
  Future saveCredentials(User userCredentials);
  Future deleteCredentials();
  Future<User?> getSavedCredentials();
}
