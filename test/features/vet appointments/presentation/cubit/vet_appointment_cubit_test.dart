import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pet_alert_app/features/vet%20appointments/domain/entity/appointment_entity.dart';
import 'package:pet_alert_app/features/vet%20appointments/domain/use_case/add_vet_appointment_use_case.dart';
import 'package:pet_alert_app/features/vet%20appointments/domain/use_case/delete_vet_appointment_use_case.dart';
import 'package:pet_alert_app/features/vet%20appointments/domain/use_case/get_appointments_use_case.dart';
import 'package:pet_alert_app/features/vet%20appointments/domain/use_case/update_vet_appointment_use_case.dart';
import 'package:pet_alert_app/features/vet%20appointments/presentation/view_model/vet_appointment_cubit.dart';
import 'package:pet_alert_app/features/vet%20appointments/presentation/view_model/vet_appointment_state.dart';

class MockGet extends Mock implements GetAppointmentsUseCase {}
class MockAdd extends Mock implements AddVetAppointmentUseCase {}
class MockUpdate extends Mock implements UpdateVetAppointmentUseCase {}
class MockDelete extends Mock implements DeleteVetAppointmentUseCase {}

void main() {
  late VetAppointmentCubit cubit;
  late MockGet mockGet;
  late MockAdd mockAdd;
  late MockUpdate mockUpdate;
  late MockDelete mockDelete;

  setUp(() {
    mockGet = MockGet();
    mockAdd = MockAdd();
    mockUpdate = MockUpdate();
    mockDelete = MockDelete();

    cubit = VetAppointmentCubit(
      getUseCase: mockGet,
      addUseCase: mockAdd,
      updateUseCase: mockUpdate,
      deleteUseCase: mockDelete,
    );
  });

  final sample = [
    AppointmentEntity(id: '1', date: '2025-08-01', time: '09:00', notes: 'Routine'),
  ];

  blocTest<VetAppointmentCubit, VetAppointmentState>(
    'emits [Loading, Loaded] when loadAppointments is called',
    build: () {
      when(() => mockGet()).thenAnswer((_) async => sample);
      return cubit;
    },
    act: (cubit) => cubit.loadAppointments(),
    expect: () => [
      isA<VetAppointmentLoading>(),
      isA<VetAppointmentLoaded>().having((s) => s.appointments.length, 'length', 1),
    ],
    verify: (_) => verify(() => mockGet()).called(1),
  );
}
