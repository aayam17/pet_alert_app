import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_alert_app/features/memorials/presentation/view/memorials_screen.dart';
import 'package:pet_alert_app/features/memorials/presentation/view_model/memorial_cubit.dart';
import 'package:pet_alert_app/features/memorials/presentation/view_model/memorial_state.dart';
import 'package:pet_alert_app/features/memorials/domain/entity/memorial_entity.dart';
import 'package:mocktail/mocktail.dart';

class MockMemorialCubit extends Mock implements MemorialCubit {}

void main() {
  testWidgets('displays memorial entries when loaded', (tester) async {
    final mockCubit = MockMemorialCubit();
    final entries = [
      MemorialEntity(
        id: '1',
        petName: 'Tommy',
        message: 'Loved forever',
        dateOfPassing: '2025-08-01',
        imageUrl: '',
      )
    ];

    when(() => mockCubit.state).thenReturn(MemorialLoaded(entries));
    when(() => mockCubit.stream).thenAnswer((_) => Stream.value(MemorialLoaded(entries)));

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<MemorialCubit>.value(
          value: mockCubit,
          child: const MemorialsScreen(),
        ),
      ),
    );

    expect(find.text('Tommy'), findsOneWidget);
    expect(find.textContaining('Passed on:'), findsOneWidget);
  });
}
