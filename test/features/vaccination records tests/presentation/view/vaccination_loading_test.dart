import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pet_alert_app/features/vaccination records/presentation/view/vaccination_records_screen.dart';
import 'package:pet_alert_app/features/vaccination records/presentation/view_model/vaccination_cubit.dart';
import 'package:pet_alert_app/features/vaccination records/presentation/view_model/vaccination_state.dart';

class MockVaccinationCubit extends Mock implements VaccinationCubit {}

void main() {
  testWidgets('shows loading indicator when state is VaccinationLoading', (tester) async {
    final mockCubit = MockVaccinationCubit();

    // ✅ Mock both .state and .stream
    when(() => mockCubit.state).thenReturn(VaccinationLoading());
    when(() => mockCubit.stream).thenAnswer((_) => Stream<VaccinationState>.value(VaccinationLoading()));
    when(() => mockCubit.loadRecords()).thenAnswer((_) {}); // if your screen calls loadRecords()

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<VaccinationCubit>.value(
          value: mockCubit,
          child: const VaccinationRecordsScreen(),
        ),
      ),
    );

    // Allow time for widgets to build
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
