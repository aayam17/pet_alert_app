// domain/use_case/delete_vet_appointment_use_case.dart
import 'package:pet_alert_app/features/vet%20appointments/domain/repository/appointment_repository.dart';


class DeleteVetAppointmentUseCase {
  final AppointmentRepository repository;

  DeleteVetAppointmentUseCase(this.repository);

  Future<void> call(String id) {
    return repository.deleteAppointment(id);
  }
}
