import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pet_alert_app/features/auth/presentation/view/signup_page.dart';
import 'package:pet_alert_app/features/auth/presentation/view_model/signup/signup_bloc.dart';
import 'package:pet_alert_app/features/auth/presentation/view_model/signup/signup_event.dart';
import 'package:pet_alert_app/features/auth/presentation/view_model/signup/signup_state.dart';


class MockSignupBloc extends Mock implements SignupBloc {}

class FakeSignupEvent extends Fake implements SignupEvent {}
class FakeSignupState extends Fake implements SignupState {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeSignupEvent());
    registerFallbackValue(FakeSignupState());
  });

  testWidgets('should trigger SignupSubmitted when tapping Sign Up button',
      (tester) async {
    final bloc = MockSignupBloc();

    when(() => bloc.state).thenReturn(SignupState.initial());
    whenListen(
      bloc,
      Stream<SignupState>.empty(),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<SignupBloc>(
          create: (_) => bloc,
          child: const SignupPage(),
        ),
      ),
    );

    // enter name
    await tester.enterText(
      find.byType(TextFormField).at(0),
      'Test User',
    );

    // enter email
    await tester.enterText(
      find.byType(TextFormField).at(1),
      'test@email.com',
    );

    // enter password
    await tester.enterText(
      find.byType(TextFormField).at(2),
      'password123',
    );

    // tap checkbox
    await tester.tap(find.byType(Checkbox));
    await tester.pump();

    await tester.tap(find.text('Sign Up'));
    await tester.pump();

    verify(() => bloc.add(any(that: isA<SignupSubmitted>()))).called(1);
  });
}
