import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pet_alert_app/features/lost and found/presentation/view_model/lost_and_found_cubit.dart';
import 'package:pet_alert_app/features/lost and found/presentation/view_model/lost_and_found_state.dart';
import 'package:pet_alert_app/features/lost%20and%20found/presentation/view/lost_and_found.dart';

class MockLostAndFoundCubit extends Mock implements LostAndFoundCubit {}

void main() {
  testWidgets('shows CircularProgressIndicator when loading', (tester) async {
    final mockCubit = MockLostAndFoundCubit();

    when(() => mockCubit.state).thenReturn(LostAndFoundLoading());
    when(() => mockCubit.stream).thenAnswer((_) => Stream.value(LostAndFoundLoading()));

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<LostAndFoundCubit>.value(
          value: mockCubit,
          child: const LostAndFoundScreen(),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
