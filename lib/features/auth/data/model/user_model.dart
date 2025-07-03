import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
// ignore: must_be_immutable
class AuthApiModel extends HiveObject with EquatableMixin {
  @HiveField(0)
  final String email;

  @HiveField(1)
  final String password;

  @HiveField(2)
  final String name;

  @HiveField(3)
  final String token;

  AuthApiModel({
    required this.email,
    required this.password,
    required this.name,
    required this.token,
  });

  factory AuthApiModel.fromJson(Map<String, dynamic> json) {
    final userJson = json['user'] ?? {};

    return AuthApiModel(
      name: userJson['username'] ?? '',
      email: userJson['email'] ?? '',
      password: '', // password is not returned
      token: json['token'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'username': name,
        'email': email,
        'password': password,
        'token': token,
      };

  @override
  List<Object?> get props => [name, email, password, token];
}
