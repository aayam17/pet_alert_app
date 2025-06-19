import '../entity/auth_entity.dart';

abstract class AuthRepository {
  Future<bool> login(String email, String password);
  Future<bool> signup(AuthEntity user);
}
