// domain/use_case/update_vet_appointment_use_case.dart
import 'package:pet_alert_app/features/vet%20appointments/domain/entity/appointment_entity.dart';
import 'package:pet_alert_app/features/vet%20appointments/domain/repository/appointment_repository.dart';

class UpdateVetAppointmentUseCase {
  final AppointmentRepository repository;

  UpdateVetAppointmentUseCase(this.repository);

  Future<void> call(String id, AppointmentEntity appointment) {
    return repository.updateAppointment(id, appointment);
  }
}
