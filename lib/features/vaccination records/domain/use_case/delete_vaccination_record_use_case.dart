import '../repository/vaccination_repository.dart';

class DeleteVaccinationRecordUseCase {
  final VaccinationRepository repository;

  DeleteVaccinationRecordUseCase(this.repository);

  Future<void> call(String id) {
    return repository.deleteRecord(id);
  }
}
