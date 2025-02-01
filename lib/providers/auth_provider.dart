import 'package:flutter/foundation.dart';

import '../../models/models.dart';

import '../services/base/auth_service.dart';
import '../services/base/local_storage_service.dart';
import '../services/impl/auth_service_http_impl.dart';
import '../services/impl/local_storage_service_hive_impl.dart';

import '../utils/logger.dart';

class AuthProvider with ChangeNotifier {
  static const Logger _logger = Logger("AuthProvider");

  bool _loggedIn = false;
  Token? _token;
  User? _savedCredentials;
  bool _wasLoggedIn = false;

  final AuthService _authService = AuthServiceHttpImpl();
  final LocalStorageService _localStorageService =
      LocalStorageServiceHiveImpl();

  AuthProvider(Settings settings) {
    updateSettings(settings);
  }

  void updateSettings(Settings newSettings) {
    if (_authService is AuthServiceHttpImpl) {
      _authService.setHost(newSettings.host);
    }
  }

  Future<bool> login(User user) async {
    Token? token = await _authService.login(user);

    if (token == null) return false;

    _token = token;

    _logger.message('Decoding token...');
    _token!.decode();

    _localStorageService.saveLoginSuccess();

    _loggedIn = true;
    notifyListeners();

    return true;
  }

  Future logout() async {
    await _authService.logout();
    await _localStorageService.deleteCredentials();
    _savedCredentials = null;
    _token = null;
    _loggedIn = false;
    _wasLoggedIn = false;

    notifyListeners();
  }

  Future saveCredentials(User userCrendentials) async {
    await _localStorageService.saveCredentials(userCrendentials);
  }

  Future loadSavedCredentials() async {
    _savedCredentials = await _localStorageService.getSavedCredentials();
    _wasLoggedIn = await _localStorageService.wasLoggedInSuccessfully();
  }

  bool get isLoggedIn {
    return _loggedIn;
  }

  Token? get token {
    return _token;
  }

  bool get hasSavedCredentials {
    return _savedCredentials != null;
  }

  User get savedCredentials {
    return _savedCredentials!;
  }

  bool get wasUserLoggedIn {
    return _wasLoggedIn;
  }
}
