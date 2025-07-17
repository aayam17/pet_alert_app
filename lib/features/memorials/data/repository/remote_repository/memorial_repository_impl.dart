
import 'package:pet_alert_app/features/memorials/data/data_source/remote_datasource/memorial_remote_datasource.dart';
import 'package:pet_alert_app/features/memorials/data/model/memorial_model.dart';
import 'package:pet_alert_app/features/memorials/domain/entity/memorial_entity.dart';
import 'package:pet_alert_app/features/memorials/domain/repository/memorial_repository.dart';

class MemorialRepositoryImpl implements MemorialRepository {
  final MemorialRemoteDataSource remote;

  MemorialRepositoryImpl(this.remote);

  @override
  Future<List<MemorialEntity>> getMemorials() async {
    final dtos = await remote.fetchMemorials();
    return dtos.map((dto) => MemorialModel.fromDto(dto).toEntity()).toList();
  }

  @override
  Future<void> addMemorial(MemorialEntity memorial) async {
    final model = MemorialModel.fromEntity(memorial);
    return remote.addMemorial(model.toDto());
  }

  @override
  Future<void> updateMemorial(String id, MemorialEntity memorial) async {
    final model = MemorialModel.fromEntity(memorial);
    return remote.updateMemorial(id, model.toDto());
  }

  @override
  Future<void> deleteMemorial(String id) {
    return remote.deleteMemorial(id);
  }
}
