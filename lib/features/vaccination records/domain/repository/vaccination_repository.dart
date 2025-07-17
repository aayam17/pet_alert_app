import '../entity/vaccination_record_entity.dart';

abstract class VaccinationRepository {
  Future<List<VaccinationRecordEntity>> getRecords();
  Future<void> addRecord(VaccinationRecordEntity record);
  Future<void> updateRecord(String id, VaccinationRecordEntity record);
  Future<void> deleteRecord(String id);
}
