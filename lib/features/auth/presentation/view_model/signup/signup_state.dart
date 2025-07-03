import 'package:equatable/equatable.dart';

import '../../../data/model/user_model.dart';

class SignupState extends Equatable {
  final bool isLoading;
  final bool isSuccess;
  final String? error;
  final AuthApiModel? user;

  const SignupState({
    required this.isLoading,
    required this.isSuccess,
    this.error,
    this.user,
  });

  factory SignupState.initial() => const SignupState(
        isLoading: false,
        isSuccess: false,
        error: null,
        user: null,
      );

  SignupState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? error,
    AuthApiModel? user,
  }) {
    return SignupState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      error: error,
      user: user ?? this.user,
    );
  }

  @override
  List<Object?> get props => [isLoading, isSuccess, error, user];
}
