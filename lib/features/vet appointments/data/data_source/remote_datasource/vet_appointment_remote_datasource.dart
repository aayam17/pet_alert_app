import '../../dto/vet_appointment_dto.dart';

abstract class VetAppointmentRemoteDataSource {
  Future<List<VetAppointmentDto>> fetchAppointments();
  Future<void> addAppointment(VetAppointmentDto dto);
  Future<void> updateAppointment(String id, VetAppointmentDto dto);
  Future<void> deleteAppointment(String id);
}
