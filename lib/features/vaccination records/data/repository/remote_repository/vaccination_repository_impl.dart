import 'package:pet_alert_app/features/vaccination%20records/data/data_source/remote_datasource/vaccination_remote_datasource.dart';
import 'package:pet_alert_app/features/vaccination%20records/data/model/vaccination_model.dart';
import 'package:pet_alert_app/features/vaccination%20records/domain/entity/vaccination_record_entity.dart';
import 'package:pet_alert_app/features/vaccination%20records/domain/repository/vaccination_repository.dart';

class VaccinationRepositoryImpl implements VaccinationRepository {
  final VaccinationRemoteDataSource remoteDataSource;

  VaccinationRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<VaccinationRecordEntity>> getRecords() async {
    final dtos = await remoteDataSource.fetchRecords();
    return dtos.map((dto) => VaccinationModel.fromDto(dto).toEntity()).toList();
  }

  @override
  Future<void> addRecord(VaccinationRecordEntity record) async {
    final model = VaccinationModel(
      id: record.id,
      vaccine: record.vaccine,
      notes: record.notes,
      date: record.date,
    );
    await remoteDataSource.addRecord(model.toDto());
  }

  @override
  Future<void> updateRecord(String id, VaccinationRecordEntity record) async {
    final model = VaccinationModel(
      id: id,
      vaccine: record.vaccine,
      notes: record.notes,
      date: record.date,
    );
    await remoteDataSource.updateRecord(id, model.toDto());
  }

  @override
  Future<void> deleteRecord(String id) async {
    await remoteDataSource.deleteRecord(id);
  }
}
