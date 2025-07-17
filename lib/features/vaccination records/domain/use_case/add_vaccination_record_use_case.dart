import '../entity/vaccination_record_entity.dart';
import '../repository/vaccination_repository.dart';

class AddVaccinationRecordUseCase {
  final VaccinationRepository repository;

  AddVaccinationRecordUseCase(this.repository);

  Future<void> call(VaccinationRecordEntity record) {
    return repository.addRecord(record);
  }
}

