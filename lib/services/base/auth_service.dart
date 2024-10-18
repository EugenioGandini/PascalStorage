import '../../models/models.dart';

abstract class AuthService {
  Future<Token?> login(User user);
  Future<void> logout();
}
