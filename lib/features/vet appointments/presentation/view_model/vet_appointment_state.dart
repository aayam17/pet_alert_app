import 'package:pet_alert_app/features/vet%20appointments/domain/entity/appointment_entity.dart';
abstract class VetAppointmentState {}

class VetAppointmentInitial extends VetAppointmentState {}

class VetAppointmentLoading extends VetAppointmentState {}

class VetAppointmentLoaded extends VetAppointmentState {
  final List<AppointmentEntity> appointments;

  VetAppointmentLoaded(this.appointments);
}

class VetAppointmentError extends VetAppointmentState {
  final String message;

  VetAppointmentError(this.message);
}
