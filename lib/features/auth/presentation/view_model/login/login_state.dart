import 'package:equatable/equatable.dart';

import '../../../data/model/user_model.dart';

class LoginState extends Equatable {
  final bool isLoading;
  final bool isSuccess;
  final String? error;
  final AuthApiModel? user;

  const LoginState({
    required this.isLoading,
    required this.isSuccess,
    this.error,
    this.user,
  });

  factory LoginState.initial() {
    return const LoginState(
      isLoading: false,
      isSuccess: false,
      error: null,
      user: null,
    );
  }

  LoginState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? error,
    AuthApiModel? user,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      error: error,
      user: user ?? this.user,
    );
  }

  @override
  List<Object?> get props => [isLoading, isSuccess, error, user];
}
