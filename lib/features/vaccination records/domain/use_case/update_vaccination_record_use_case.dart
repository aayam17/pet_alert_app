import '../entity/vaccination_record_entity.dart';
import '../repository/vaccination_repository.dart';

class UpdateVaccinationRecordUseCase {
  final VaccinationRepository repository;

  UpdateVaccinationRecordUseCase(this.repository);

  Future<void> call(String id, VaccinationRecordEntity record) {
    return repository.updateRecord(id, record);
  }
}
