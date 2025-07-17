// data/repository/lost_and_found_repository_impl.dart
import 'package:pet_alert_app/features/lost%20and%20found/data/data_source/remote_datasource/lost_and_found_remote_datasource.dart';
import 'package:pet_alert_app/features/lost%20and%20found/domian/entity/lost_and_found_entity.dart';
import 'package:pet_alert_app/features/lost%20and%20found/domian/repository/lost_and_found_repository.dart';
import '../../model/lost_and_found_model.dart';

class LostAndFoundRepositoryImpl implements LostAndFoundRepository {
  final LostAndFoundRemoteDataSource remote;

  LostAndFoundRepositoryImpl(this.remote);

  @override
  Future<List<LostAndFoundEntity>> getEntries() async {
    final dtos = await remote.fetchEntries();
    return dtos.map((dto) => LostAndFoundModel.fromDto(dto).toEntity()).toList();
  }

  @override
  Future<void> addEntry(LostAndFoundEntity entry) {
    final model = LostAndFoundModel.fromEntity(entry);
    return remote.addEntry(model.toDto());
  }

  @override
  Future<void> updateEntry(String id, LostAndFoundEntity entry) {
    final model = LostAndFoundModel.fromEntity(entry);
    return remote.updateEntry(id, model.toDto());
  }

  @override
  Future<void> deleteEntry(String id) {
    return remote.deleteEntry(id);
  }
}
