import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pet_alert_app/features/auth/data/model/user_model.dart';
import 'package:pet_alert_app/features/auth/domain/entity/auth_entity.dart';
import 'package:pet_alert_app/features/auth/domain/use_case/signup_usecase.dart';
import 'package:pet_alert_app/features/auth/presentation/view_model/signup/signup_bloc.dart';
import 'package:pet_alert_app/features/auth/presentation/view_model/signup/signup_event.dart';
import 'package:pet_alert_app/features/auth/presentation/view_model/signup/signup_state.dart';

class MockSignupUseCase extends Mock implements SignupUseCase {}
class MockHiveBox extends Mock implements Box {}
class FakeBuildContext extends Fake implements BuildContext {}

void main() {
  late SignupBloc signupBloc;
  late MockSignupUseCase mockSignupUseCase;
  late MockHiveBox mockBox;

  setUp(() {
    mockSignupUseCase = MockSignupUseCase();
    mockBox = MockHiveBox();

    when(() => Hive.openBox(any())).thenAnswer((_) async => mockBox);
    signupBloc = SignupBloc(signupUseCase: mockSignupUseCase);
  });

  const name = 'New User';
  const email = 'new@email.com';
  const password = 'pass123';
  final context = FakeBuildContext();

  final authEntity = AuthEntity(
    name: name,
    email: email,
    password: password,
  );

  final user = AuthApiModel(
    email: email,
    password: '',
    name: name,
    token: 'xyz456',
  );

  blocTest<SignupBloc, SignupState>(
    'emits loading and success and saves token when signup succeeds',
    build: () {
      when(() => mockSignupUseCase(any()))
          .thenAnswer((_) async => user);
      when(() => mockBox.put('token', user.token))
          .thenAnswer((_) async => Future.value());
      return signupBloc;
    },
    act: (bloc) => bloc.add(SignupSubmitted(
      name: name,
      email: email,
      password: password,
      context: context,
    )),
    expect: () => [
      SignupState.initial().copyWith(isLoading: true),
      SignupState.initial().copyWith(
        isLoading: false,
        isSuccess: true,
        user: user,
      )
    ],
    verify: (_) {
      verify(() => mockSignupUseCase(any())).called(1);
      verify(() => mockBox.put('token', user.token)).called(1);
    },
  );

  blocTest<SignupBloc, SignupState>(
    'emits loading and error when signup fails',
    build: () {
      when(() => mockSignupUseCase(any()))
          .thenThrow(Exception('Signup failed'));
      return signupBloc;
    },
    act: (bloc) => bloc.add(SignupSubmitted(
      name: name,
      email: email,
      password: password,
      context: context,
    )),
    expect: () => [
      SignupState.initial().copyWith(isLoading: true),
      SignupState.initial().copyWith(
        isLoading: false,
        isSuccess: false,
        error: 'Signup failed: Exception: Signup failed',

      )
    ],
    verify: (_) {
      verify(() => mockSignupUseCase(any())).called(1);
    },
  );
}
