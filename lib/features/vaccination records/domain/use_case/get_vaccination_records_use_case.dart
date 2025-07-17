import '../entity/vaccination_record_entity.dart';
import '../repository/vaccination_repository.dart';

class GetVaccinationRecordsUseCase {
  final VaccinationRepository repository;

  GetVaccinationRecordsUseCase(this.repository);

  Future<List<VaccinationRecordEntity>> call() {
    return repository.getRecords();
  }
}
