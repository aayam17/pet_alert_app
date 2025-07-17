import 'package:pet_alert_app/features/vet%20appointments/domain/entity/appointment_entity.dart';

abstract class AppointmentRepository {
  Future<List<AppointmentEntity>> getAppointments();
  Future<void> addAppointment(AppointmentEntity appointment);
  Future<void> updateAppointment(String id, AppointmentEntity appointment); 
  Future<void> deleteAppointment(String id);
}
