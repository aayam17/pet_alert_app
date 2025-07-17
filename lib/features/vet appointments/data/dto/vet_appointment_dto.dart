import 'package:pet_alert_app/features/vet%20appointments/domain/entity/appointment_entity.dart';

class VetAppointmentDto {
  final String id;
  final String date;
  final String time;
  final String notes;

  VetAppointmentDto({
    required this.id,
    required this.date,
    required this.time,
    required this.notes,
  });

  factory VetAppointmentDto.fromJson(Map<String, dynamic> json) {
    return VetAppointmentDto(
      id: json['_id'] ?? '',
      date: json['date'],
      time: json['time'],
      notes: json['notes'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'time': time,
      'notes': notes,
    };
  }

  AppointmentEntity toEntity() {
    return AppointmentEntity(id: id, date: date, time: time, notes: notes);
  }

  static VetAppointmentDto fromEntity(AppointmentEntity entity) {
    return VetAppointmentDto(
      id: entity.id,
      date: entity.date,
      time: entity.time,
      notes: entity.notes,
    );
  }
}
