import 'package:pet_alert_app/features/vaccination%20records/data/dto/vaccination_record_dto.dart';

abstract class VaccinationRemoteDataSource {
  Future<List<VaccinationRecordDto>> fetchRecords();
  Future<void> addRecord(VaccinationRecordDto dto);
  Future<void> updateRecord(String id, VaccinationRecordDto dto);
  Future<void> deleteRecord(String id);
}
