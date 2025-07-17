import '../entity/lost_and_found_entity.dart';

abstract class LostAndFoundRepository {
  Future<List<LostAndFoundEntity>> getEntries();
  Future<void> addEntry(LostAndFoundEntity entry);
  Future<void> updateEntry(String id, LostAndFoundEntity entry);
  Future<void> deleteEntry(String id);
}
