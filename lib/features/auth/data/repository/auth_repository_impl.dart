import '../../domain/entity/auth_entity.dart';
import '../../domain/repository/auth_repository.dart';
import '../data_source/local_datasource/auth_local_datasource.dart';
import '../data_source/remote_datasource/auth_remote_datasource.dart';
import '../model/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource localDataSource;
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<AuthApiModel> login(String email, String password) async {
    // ✅ Call API
    final remoteUser = await remoteDataSource.login(email, password);

    // ✅ Save to Hive (if you want to cache the user locally)
    await localDataSource.signup(remoteUser);

    return remoteUser;
  }

  @override
  Future<AuthApiModel> signup(AuthEntity user) async {
    // ✅ Call API
    final remoteUser = await remoteDataSource.signup(
      user.name,
      user.email,
      user.password,
    );

    // ✅ Save to Hive (for local persistence)
    await localDataSource.signup(remoteUser);

    return remoteUser;
  }
}
