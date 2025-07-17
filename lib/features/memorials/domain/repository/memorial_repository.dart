import '../entity/memorial_entity.dart';

abstract class MemorialRepository {
  Future<List<MemorialEntity>> getMemorials();
  Future<void> addMemorial(MemorialEntity memorial);
  Future<void> updateMemorial(String id, MemorialEntity memorial);
  Future<void> deleteMemorial(String id);
}
