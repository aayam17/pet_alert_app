import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_alert_app/features/vet%20appointments/presentation/view/vet_appointments_screen.dart';
import 'package:pet_alert_app/features/vet%20appointments/presentation/view_model/vet_appointment_cubit.dart';
import 'package:pet_alert_app/features/vet%20appointments/presentation/view_model/vet_appointment_state.dart';
import 'package:mocktail/mocktail.dart';

class MockCubit extends Mock implements VetAppointmentCubit {}

void main() {
  late MockCubit mockCubit;

  setUp(() {
    mockCubit = MockCubit();
    // ✅ Stub state and stream
    when(() => mockCubit.state).thenReturn(VetAppointmentLoading());
    when(() => mockCubit.stream).thenAnswer((_) => const Stream.empty());
  });

  testWidgets('displays loading indicator when state is loading', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<VetAppointmentCubit>.value(
          value: mockCubit,
          child: const VetAppointmentsScreen(),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
