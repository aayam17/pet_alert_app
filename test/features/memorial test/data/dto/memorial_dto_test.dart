import 'package:flutter_test/flutter_test.dart';
import 'package:pet_alert_app/features/memorials/data/dto/memorial_dto.dart';

void main() {
  test('MemorialDto toJson and fromJson should work correctly', () {
    final dto = MemorialDto(
      id: '1',
      petName: 'Tommy',
      message: 'Loved forever',
      dateOfPassing: '2025-08-01',
      imageUrl: 'https://image.jpg',
    );

    final json = dto.toJson();
    final parsed = MemorialDto.fromJson({...json, '_id': '1'});

    expect(parsed.id, '1');
    expect(parsed.petName, 'Tommy');
  });
}
