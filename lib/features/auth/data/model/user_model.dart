import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:pet_alert_app/features/auth/domain/entity/auth_entity.dart'; // 

part 'user_model.g.dart';

@HiveType(typeId: 0)
class AuthApiModel extends HiveObject with EquatableMixin {
  @HiveField(0)
  final String email;

  @HiveField(1)
  final String password;

  AuthApiModel({
    required this.email,
    required this.password,
  });

  AuthEntity toEntity() => AuthEntity(
        email: email,
        password: password,
      );

  factory AuthApiModel.fromEntity(AuthEntity entity) => AuthApiModel(
        email: entity.email,
        password: entity.password,
      );

  @override
  List<Object?> get props => [email, password];
}
