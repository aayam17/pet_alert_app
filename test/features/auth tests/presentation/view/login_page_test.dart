import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pet_alert_app/features/auth/domain/use_case/login_usecase.dart';
import 'package:pet_alert_app/features/auth/presentation/view/login_page.dart';
import 'package:pet_alert_app/features/auth/presentation/view_model/login/login_bloc.dart';
import 'package:pet_alert_app/features/auth/presentation/view_model/login/login_event.dart';
import 'package:pet_alert_app/features/auth/presentation/view_model/login/login_state.dart';


import '../bloc/login/login_bloc_test.dart';

class MockLoginBloc extends Mock implements LoginBloc {}

class FakeLoginEvent extends Fake implements LoginEvent {}
class FakeLoginState extends Fake implements LoginState {}

void main() {
  final sl = GetIt.instance;

  setUpAll(() {
    registerFallbackValue(FakeLoginEvent());
    registerFallbackValue(FakeLoginState());

    sl.registerLazySingleton<LoginUseCase>(() => MockLoginUseCase());
  });

  tearDownAll(() {
    sl.reset();
  });

  testWidgets('should trigger LoginSubmitted when tapping Log In button',
      (tester) async {
    final bloc = MockLoginBloc();

    when(() => bloc.state).thenReturn(LoginState.initial());
    whenListen(
      bloc,
      Stream<LoginState>.empty(),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<LoginBloc>(
          create: (_) => bloc,
          child: const LoginPage(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // debug widget tree if needed
    // debugPrint(tester.binding.renderViewElement!.toStringDeep());

    // enter email
    await tester.enterText(
      find.byType(TextFormField).at(0),
      'test@email.com',
    );

    // enter password
    await tester.enterText(
      find.byType(TextFormField).at(1),
      'password123',
    );

    await tester.tap(find.widgetWithText(ElevatedButton, 'Log In'));
    await tester.pump();

    verify(() => bloc.add(any(that: isA<LoginSubmitted>()))).called(1);
  });
}
