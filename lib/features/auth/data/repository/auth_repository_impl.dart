import 'package:pet_alert_app/features/auth/data/data_source/local_datasource/auth_local_datasource.dart';
import 'package:pet_alert_app/features/auth/data/model/user_model.dart';
import 'package:pet_alert_app/features/auth/domain/entity/auth_entity.dart';
import 'package:pet_alert_app/features/auth/domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl(this.localDataSource);

  @override
  Future<bool> login(String email, String password) {
    return localDataSource.login(email, password);
  }

  @override
  Future<bool> signup(AuthEntity user) {
    final model = AuthApiModel.fromEntity(user);
    return localDataSource.signup(model);
  }
}
