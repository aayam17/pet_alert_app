// vaccination_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_alert_app/features/vaccination%20records/domain/entity/vaccination_record_entity.dart';
import 'package:pet_alert_app/features/vaccination%20records/domain/use_case/add_vaccination_record_use_case.dart';
import 'package:pet_alert_app/features/vaccination%20records/domain/use_case/delete_vaccination_record_use_case.dart';
import 'package:pet_alert_app/features/vaccination%20records/domain/use_case/get_vaccination_records_use_case.dart';
import 'package:pet_alert_app/features/vaccination%20records/domain/use_case/update_vaccination_record_use_case.dart';

import 'vaccination_state.dart';

class VaccinationCubit extends Cubit<VaccinationState> {
  final GetVaccinationRecordsUseCase getUseCase;
  final AddVaccinationRecordUseCase addUseCase;
  final UpdateVaccinationRecordUseCase updateUseCase;
  final DeleteVaccinationRecordUseCase deleteUseCase;

  VaccinationCubit({
    required this.getUseCase,
    required this.addUseCase,
    required this.updateUseCase,
    required this.deleteUseCase,
  }) : super(VaccinationInitial());

  void loadRecords() async {
    emit(VaccinationLoading());
    try {
      final records = await getUseCase();
      emit(VaccinationLoaded(records));
    } catch (_) {
      emit(VaccinationError("Failed to load records."));
    }
  }

  void addRecord(VaccinationRecordEntity record) async {
    try {
      await addUseCase(record);
      loadRecords();
    } catch (_) {
      emit(VaccinationError("Failed to add record."));
    }
  }

  void updateRecord(String id, VaccinationRecordEntity record) async {
    try {
      await updateUseCase(id, record);
      loadRecords();
    } catch (_) {
      emit(VaccinationError("Failed to update record."));
    }
  }

  void deleteRecord(String id) async {
    try {
      await deleteUseCase(id);
      loadRecords();
    } catch (_) {
      emit(VaccinationError("Failed to delete record."));
    }
  }
}
