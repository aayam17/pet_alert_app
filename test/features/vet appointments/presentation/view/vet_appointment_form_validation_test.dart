import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pet_alert_app/features/vet%20appointments/presentation/view/vet_appointments_screen.dart';
import 'package:pet_alert_app/features/vet%20appointments/presentation/view_model/vet_appointment_cubit.dart';
import 'package:pet_alert_app/features/vet%20appointments/presentation/view_model/vet_appointment_state.dart';

class MockVetAppointmentCubit extends Mock implements VetAppointmentCubit {}

void main() {
  late MockVetAppointmentCubit mockCubit;

  setUp(() {
    mockCubit = MockVetAppointmentCubit();

    // ✅ Must stub `state` and `stream`
    when(() => mockCubit.state).thenReturn(VetAppointmentInitial());
    when(() => mockCubit.stream).thenAnswer((_) => const Stream.empty());
  });

  testWidgets('shows validation when date and time are not selected', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<VetAppointmentCubit>.value(
          value: mockCubit,
          child: const VetAppointmentsScreen(),
        ),
      ),
    );

    await tester.pump(); // Let widget settle

    // ✅ Optional: debug output if test fails again
    // debugDumpApp();

    final addButton = find.text('Add Appointment');
    expect(addButton, findsOneWidget);

    await tester.tap(addButton);
    await tester.pump();

    expect(find.text('Please select date and time.'), findsOneWidget);
  });
}
