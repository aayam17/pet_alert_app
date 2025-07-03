import '../../data/model/user_model.dart';
import '../entity/auth_entity.dart';

abstract class AuthRepository {
  Future<AuthApiModel> login(String email, String password);
  Future<AuthApiModel> signup(AuthEntity user);
}
