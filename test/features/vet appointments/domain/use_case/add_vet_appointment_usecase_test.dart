import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pet_alert_app/features/vet%20appointments/domain/entity/appointment_entity.dart';
import 'package:pet_alert_app/features/vet%20appointments/domain/repository/appointment_repository.dart';
import 'package:pet_alert_app/features/vet%20appointments/domain/use_case/add_vet_appointment_use_case.dart';

class MockAppointmentRepository extends Mock implements AppointmentRepository {}

void main() {
  late MockAppointmentRepository mockRepo;
  late AddVetAppointmentUseCase useCase;

  setUp(() {
    mockRepo = MockAppointmentRepository();
    useCase = AddVetAppointmentUseCase(mockRepo);
  });

  test('should call addAppointment on repository', () async {
    final appointment = AppointmentEntity(
      id: '2',
      date: '2025-08-02',
      time: '11:00',
      notes: 'Vaccine',
    );

    // ✅ Fix: use `when(() => ...)`
    when(() => mockRepo.addAppointment(appointment))
        .thenAnswer((_) async => Future.value());

    await useCase(appointment);

    // ✅ Fix: use `verify(() => ...)`
    verify(() => mockRepo.addAppointment(appointment)).called(1);
  });
}
