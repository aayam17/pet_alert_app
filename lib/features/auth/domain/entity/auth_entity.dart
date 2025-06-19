// lib/features/auth/domain/entity/auth_entity.dart

import 'package:equatable/equatable.dart';

class AuthEntity extends Equatable {
  final String email;
  final String password;

  const AuthEntity({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}
