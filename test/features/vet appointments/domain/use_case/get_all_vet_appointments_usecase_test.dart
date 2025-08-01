import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pet_alert_app/features/vet%20appointments/domain/entity/appointment_entity.dart';
import 'package:pet_alert_app/features/vet%20appointments/domain/repository/appointment_repository.dart';
import 'package:pet_alert_app/features/vet%20appointments/domain/use_case/get_appointments_use_case.dart';

class MockAppointmentRepository extends Mock implements AppointmentRepository {}

void main() {
  late MockAppointmentRepository mockRepo;
  late GetAppointmentsUseCase useCase;

  setUp(() {
    mockRepo = MockAppointmentRepository();
    useCase = GetAppointmentsUseCase(mockRepo);
  });

  test('should return list of appointments', () async {
    final appointments = [
      AppointmentEntity(id: '1', date: '2025-08-01', time: '10:00', notes: 'Checkup'),
    ];

    // ✅ Proper mocktail usage
    when(() => mockRepo.getAppointments()).thenAnswer((_) async => appointments);

    final result = await useCase();

    expect(result, appointments);

    // ✅ Proper verify syntax
    verify(() => mockRepo.getAppointments()).called(1);
  });
}
