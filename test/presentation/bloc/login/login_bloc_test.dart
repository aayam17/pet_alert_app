import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pet_alert_app/features/auth/data/model/user_model.dart';
import 'package:pet_alert_app/features/auth/domain/use_case/login_usecase.dart';
import 'package:pet_alert_app/features/auth/presentation/view_model/login/login_bloc.dart';
import 'package:pet_alert_app/features/auth/presentation/view_model/login/login_event.dart';
import 'package:pet_alert_app/features/auth/presentation/view_model/login/login_state.dart';

class MockLoginUseCase extends Mock implements LoginUseCase {}

void main() {
  late LoginBloc loginBloc;
  late MockLoginUseCase mockLoginUseCase;

  setUp(() {
    mockLoginUseCase = MockLoginUseCase();
    loginBloc = LoginBloc(loginUseCase: mockLoginUseCase);
  });

  const email = 'test@email.com';
  const password = 'pass123';
  final context = FakeBuildContext();

  final user = AuthApiModel(
    email: email,
    password: '',
    name: 'Test User',
    token: 'abc123',
  );

  blocTest<LoginBloc, LoginState>(
    'emits loading and success when login succeeds',
    build: () {
      when(() => mockLoginUseCase(email, password))
          .thenAnswer((_) async => user);
      return loginBloc;
    },
    act: (bloc) => bloc.add(
      LoginSubmitted(email: email, password: password, context: context),
    ),
    expect: () => [
      LoginState.initial().copyWith(isLoading: true, error: null),
      LoginState.initial().copyWith(
        isLoading: false,
        isSuccess: true,
        user: user,
      )
    ],
    verify: (_) {
      verify(() => mockLoginUseCase(email, password)).called(1);
    },
  );

  blocTest<LoginBloc, LoginState>(
    'emits loading and error when login fails',
    build: () {
      when(() => mockLoginUseCase(email, password))
          .thenThrow(Exception('Invalid login'));
      return loginBloc;
    },
    act: (bloc) => bloc.add(
      LoginSubmitted(email: email, password: password, context: context),
    ),
    expect: () => [
      LoginState.initial().copyWith(isLoading: true, error: null),
      LoginState.initial().copyWith(
        isLoading: false,
        isSuccess: false,
        error: 'Login failed: Exception: Invalid login',

      )
    ],
    verify: (_) {
      verify(() => mockLoginUseCase(email, password)).called(1);
    },
  );
}

/// Dummy BuildContext for tests
class FakeBuildContext extends Fake implements BuildContext {}
