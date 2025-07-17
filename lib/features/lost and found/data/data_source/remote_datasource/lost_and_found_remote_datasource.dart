import 'package:pet_alert_app/features/lost%20and%20found/data/dto/lost_and_found_dto.dart';

abstract class LostAndFoundRemoteDataSource {
  Future<List<LostAndFoundDto>> fetchEntries();
  Future<void> addEntry(LostAndFoundDto dto);
  Future<void> updateEntry(String id, LostAndFoundDto dto);
  Future<void> deleteEntry(String id);
}
