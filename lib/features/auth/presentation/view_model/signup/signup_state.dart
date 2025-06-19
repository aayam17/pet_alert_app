import 'package:equatable/equatable.dart';

class SignupState extends Equatable {
  final bool isLoading;
  final bool isSuccess;
  final String? error;

  const SignupState({
    required this.isLoading,
    required this.isSuccess,
    this.error,
  });

  factory SignupState.initial() => const SignupState(isLoading: false, isSuccess: false);

  SignupState copyWith({bool? isLoading, bool? isSuccess, String? error}) {
    return SignupState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      error: error,
    );
  }

  @override
  List<Object?> get props => [isLoading, isSuccess, error];
}
