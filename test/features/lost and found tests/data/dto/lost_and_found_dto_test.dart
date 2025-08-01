import 'package:flutter_test/flutter_test.dart';
import 'package:pet_alert_app/features/lost and found/data/dto/lost_and_found_dto.dart';

void main() {
  test('LostAndFoundDto fromJson and toJson', () {
    final json = {
      '_id': 'abc123',
      'type': 'Lost',
      'description': 'Lost black dog',
      'location': 'Kathmandu',
      'date': '2025-08-01',
      'time': '14:00',
      'contactInfo': 'test@example.com',
    };

    final dto = LostAndFoundDto.fromJson(json);
    expect(dto.id, 'abc123');
    expect(dto.type, 'Lost');
    expect(dto.description, 'Lost black dog');

    final back = dto.toJson();
    expect(back['description'], 'Lost black dog');
    expect(back['location'], 'Kathmandu');
  });
}
