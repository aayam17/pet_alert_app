import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_alert_app/features/memorials/presentation/view/memorials_screen.dart';
import 'package:pet_alert_app/features/memorials/presentation/view_model/memorial_cubit.dart';
import 'package:pet_alert_app/features/memorials/presentation/view_model/memorial_state.dart';
import 'package:mocktail/mocktail.dart';

class MockMemorialCubit extends Mock implements MemorialCubit {}

void main() {
  testWidgets('displays loading spinner when in MemorialLoading', (tester) async {
    final mockCubit = MockMemorialCubit();
    when(() => mockCubit.state).thenReturn(MemorialLoading());
    when(() => mockCubit.stream).thenAnswer((_) => Stream.value(MemorialLoading()));

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<MemorialCubit>.value(
          value: mockCubit,
          child: const MemorialsScreen(),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
