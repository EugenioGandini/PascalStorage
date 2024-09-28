import 'package:flutter/foundation.dart';

import 'package:filebrowser/models/models.dart';

import 'package:filebrowser/services/base/auth_service.dart';
import 'package:filebrowser/services/impl/auth_service_impl.dart';

import 'package:filebrowser/utils/logger.dart';

class AuthProvider with ChangeNotifier {
  static const Logger _logger = Logger("AuthProvider");

  bool _loggedIn = false;
  Token? _token;

  final AuthService _authService = AuthServiceImpl();

  Future<bool> login(User user) async {
    Token? token = await _authService.login(user);

    if (token == null) return false;

    _token = token;

    _logger.message('Decoding token...');
    _token!.decode();

    _loggedIn = true;
    notifyListeners();

    return true;
  }

  Future logout() async {
    await _authService.logout();
  }

  bool get isLoggedIn {
    return _loggedIn;
  }

  Token? get token {
    return _token;
  }
}
