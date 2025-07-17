import 'package:pet_alert_app/features/vet%20appointments/domain/entity/appointment_entity.dart';
import '../../dto/vet_appointment_dto.dart';
import '../../data_source/remote_datasource/vet_appointment_remote_datasource.dart';
import 'package:pet_alert_app/features/vet%20appointments/domain/repository/appointment_repository.dart';

class VetAppointmentRepositoryImpl implements AppointmentRepository {
  final VetAppointmentRemoteDataSource remote;

  VetAppointmentRepositoryImpl(this.remote);

  @override
  Future<List<AppointmentEntity>> getAppointments() async {
    final dtos = await remote.fetchAppointments();
    return dtos.map((dto) => dto.toEntity()).toList();
  }

  @override
  Future<void> addAppointment(AppointmentEntity appointment) {
    final dto = VetAppointmentDto.fromEntity(appointment);
    return remote.addAppointment(dto);
  }

  @override
  Future<void> updateAppointment(String id, AppointmentEntity appointment) {
    final dto = VetAppointmentDto.fromEntity(appointment);
    return remote.updateAppointment(id, dto);
  }

  @override
  Future<void> deleteAppointment(String id) {
    return remote.deleteAppointment(id);
  }
}
