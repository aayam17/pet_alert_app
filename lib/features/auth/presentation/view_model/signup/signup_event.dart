import 'package:flutter/material.dart';

@immutable
abstract class SignupEvent {}

class SignupSubmitted extends SignupEvent {
  final String name;
  final String email;
  final String password;
  final BuildContext context;

  SignupSubmitted({
    required this.name,
    required this.email,
    required this.password,
    required this.context,
  });
}
