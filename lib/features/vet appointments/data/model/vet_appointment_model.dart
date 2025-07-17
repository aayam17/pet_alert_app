import 'package:pet_alert_app/features/vet%20appointments/domain/entity/appointment_entity.dart';
import '../dto/vet_appointment_dto.dart';

class VetAppointmentModel extends AppointmentEntity {
  VetAppointmentModel({
    required super.id,
    required super.date,
    required super.time,
    required super.notes,
  });

  factory VetAppointmentModel.fromDto(VetAppointmentDto dto) {
    return VetAppointmentModel(
      id: dto.id,
      date: dto.date,
      time: dto.time,
      notes: dto.notes,
    );
  }

  VetAppointmentDto toDto() {
    return VetAppointmentDto(
      id: id,
      date: date,
      time: time,
      notes: notes,
    );
  }
}
