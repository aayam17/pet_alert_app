import 'package:flutter_test/flutter_test.dart';
import 'package:pet_alert_app/features/lost and found/data/dto/lost_and_found_dto.dart';
import 'package:pet_alert_app/features/lost and found/data/model/lost_and_found_model.dart';

void main() {
  test('Model to and from DTO works correctly', () {
    final dto = LostAndFoundDto(
      id: 'id1',
      type: 'Lost',
      description: 'Missing pet',
      location: 'Lalitpur',
      date: '2025-08-01',
      time: '13:00',
      contactInfo: 'owner@example.com',
    );

    final model = LostAndFoundModel.fromDto(dto);
    final entity = model.toEntity();
    final backDto = model.toDto();

    expect(entity.type, 'Lost');
    expect(backDto.description, 'Missing pet');
  });
}
