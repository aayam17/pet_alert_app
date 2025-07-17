import '../entity/appointment_entity.dart';
import '../repository/appointment_repository.dart';

class GetAppointmentsUseCase {
  final AppointmentRepository repository;

  GetAppointmentsUseCase(this.repository);

  Future<List<AppointmentEntity>> call() {
    return repository.getAppointments();
  }
}
