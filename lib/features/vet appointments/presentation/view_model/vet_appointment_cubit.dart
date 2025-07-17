import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_alert_app/features/vet%20appointments/domain/entity/appointment_entity.dart';
import 'package:pet_alert_app/features/vet%20appointments/domain/use_case/add_vet_appointment_use_case.dart';
import 'package:pet_alert_app/features/vet%20appointments/domain/use_case/delete_vet_appointment_use_case.dart';
import 'package:pet_alert_app/features/vet%20appointments/domain/use_case/get_appointments_use_case.dart';
import 'package:pet_alert_app/features/vet%20appointments/domain/use_case/update_vet_appointment_use_case.dart';

import 'vet_appointment_state.dart';

class VetAppointmentCubit extends Cubit<VetAppointmentState> {
  final GetAppointmentsUseCase getUseCase;
  final AddVetAppointmentUseCase addUseCase;
  final UpdateVetAppointmentUseCase updateUseCase;
  final DeleteVetAppointmentUseCase deleteUseCase;

  VetAppointmentCubit({
    required this.getUseCase,
    required this.addUseCase,
    required this.updateUseCase,
    required this.deleteUseCase,
  }) : super(VetAppointmentInitial());

  void loadAppointments() async {
    emit(VetAppointmentLoading());
    try {
      final appointments = await getUseCase();
      emit(VetAppointmentLoaded(appointments));
    } catch (e) {
      emit(VetAppointmentError("Failed to load appointments"));
    }
  }

  void addAppointment(AppointmentEntity appt) async {
    try {
      await addUseCase(appt);
      loadAppointments();
    } catch (e) {
      emit(VetAppointmentError("Failed to add appointment"));
    }
  }

  void updateAppointment(String id, AppointmentEntity appt) async {
    try {
      await updateUseCase(id, appt);
      loadAppointments();
    } catch (e) {
      emit(VetAppointmentError("Failed to update appointment"));
    }
  }

  void deleteAppointment(String id) async {
    try {
      await deleteUseCase(id);
      loadAppointments();
    } catch (e) {
      emit(VetAppointmentError("Failed to delete appointment"));
    }
  }
}
