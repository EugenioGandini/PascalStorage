import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../models/models.dart';
import '../../utils/logger.dart';

import './http_api.dart';

import '../base/auth_service.dart';

class AuthServiceHttpImpl extends AuthService {
  static const Logger _logger = Logger("AuthService");

  String _baseUrl = '';

  void setHost(String host) {
    _baseUrl = host;
  }

  @override
  Future<Token?> login(User user) async {
    try {
      final url = Uri.parse("$_baseUrl${HttpApi.doLogin}");
      final response = await http.post(
        url,
        body: jsonEncode({
          'username': user.username,
          'password': user.password,
          'recaptcha': ''
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode != 200) {
        _logger.message("Failed to login");
        return null;
      }

      _logger.message('Login succeeded');

      var body = response.body;

      Token loginToken = Token(jwtBase64: body);

      return loginToken;
    } catch (error) {
      _logger.message("Error calling API login ${error.toString()}");
    }

    return null;
  }

  @override
  Future<void> logout() async {}
}
