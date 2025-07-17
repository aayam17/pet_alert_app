// vaccination_state.dart
import 'package:pet_alert_app/features/vaccination%20records/domain/entity/vaccination_record_entity.dart';


abstract class VaccinationState {}

class VaccinationInitial extends VaccinationState {}

class VaccinationLoading extends VaccinationState {}

class VaccinationLoaded extends VaccinationState {
  final List<VaccinationRecordEntity> records;
  VaccinationLoaded(this.records);
}

class VaccinationError extends VaccinationState {
  final String message;
  VaccinationError(this.message);
}
