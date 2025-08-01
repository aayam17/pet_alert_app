import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pet_alert_app/features/vaccination records/domain/entity/vaccination_record_entity.dart';
import 'package:pet_alert_app/features/vaccination records/presentation/view/vaccination_records_screen.dart';
import 'package:pet_alert_app/features/vaccination records/presentation/view_model/vaccination_cubit.dart';
import 'package:pet_alert_app/features/vaccination records/presentation/view_model/vaccination_state.dart';

class MockVaccinationCubit extends Mock implements VaccinationCubit {}

void main() {
  testWidgets('displays vaccination list when loaded', (tester) async {
    final mockCubit = MockVaccinationCubit();

    // Create a broadcast stream for compatibility
    final controller = StreamController<VaccinationState>.broadcast();

    addTearDown(() async {
      await controller.close();
    });

    when(() => mockCubit.state).thenReturn(
      VaccinationLoaded([
        VaccinationRecordEntity(
          id: '1',
          vaccine: 'Rabies',
          notes: 'Booster',
          date: '2025-08-01',
        ),
      ]),
    );

    when(() => mockCubit.stream).thenAnswer((_) => controller.stream);
    when(() => mockCubit.loadRecords()).thenAnswer((_) {});

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<VaccinationCubit>.value(
          value: mockCubit,
          child: const VaccinationRecordsScreen(),
        ),
      ),
    );

    // Important: Let the widget fully build after state
    await tester.pump();

    expect(find.textContaining('Rabies'), findsOneWidget);
    expect(find.textContaining('Booster'), findsOneWidget);
  });
}
