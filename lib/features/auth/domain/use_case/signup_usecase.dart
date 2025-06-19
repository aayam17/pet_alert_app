import '../entity/auth_entity.dart';
import '../repository/auth_repository.dart';

class SignupUseCase {
  final AuthRepository repository;

  SignupUseCase(this.repository);

  Future<bool> call(AuthEntity user) {
    return repository.signup(user);
  }
}
