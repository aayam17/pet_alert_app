
import 'package:pet_alert_app/features/vet%20appointments/domain/entity/appointment_entity.dart';
import 'package:pet_alert_app/features/vet%20appointments/domain/repository/appointment_repository.dart';

class AddVetAppointmentUseCase {
  final AppointmentRepository repository;

  AddVetAppointmentUseCase(this.repository);

  Future<void> call(AppointmentEntity appointment) {
    return repository.addAppointment(appointment);
  }
}
