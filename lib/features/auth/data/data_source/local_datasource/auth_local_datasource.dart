import 'package:hive/hive.dart';
import '../../model/user_model.dart';

abstract class AuthLocalDataSource {
  Future<bool> login(String email, String password);
  Future<bool> signup(AuthApiModel user);
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final Box<AuthApiModel> box;

  AuthLocalDataSourceImpl(this.box);

  @override
  Future<bool> login(String email, String password) async {
    final user = box.values.firstWhere(
      (u) => u.email == email && u.password == password,
      orElse: () => AuthApiModel(email: '', password: '', name: '', token: ''),
    );
    return user.email.isNotEmpty;
  }

  @override
  Future<bool> signup(AuthApiModel user) async {
    final exists = box.values.any((u) => u.email == user.email);
    if (exists) return false;
    await box.add(user);
    return true;
  }
}
