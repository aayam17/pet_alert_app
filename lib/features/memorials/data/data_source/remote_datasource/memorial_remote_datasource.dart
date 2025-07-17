import 'package:pet_alert_app/features/memorials/data/dto/memorial_dto.dart';

abstract class MemorialRemoteDataSource {
  Future<List<MemorialDto>> fetchMemorials();
  Future<void> addMemorial(MemorialDto dto);
  Future<void> updateMemorial(String id, MemorialDto dto);
  Future<void> deleteMemorial(String id);
  Future<String> uploadImage(String filePath);
}
