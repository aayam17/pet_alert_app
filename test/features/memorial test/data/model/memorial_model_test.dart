import 'package:flutter_test/flutter_test.dart';
import 'package:pet_alert_app/features/memorials/domain/entity/memorial_entity.dart';
import 'package:pet_alert_app/features/memorials/data/model/memorial_model.dart';

void main() {
  test('MemorialModel conversion to/from entity', () {
    final entity = MemorialEntity(
      id: '2',
      petName: 'Leo',
      message: 'In our hearts',
      dateOfPassing: '2025-07-20',
      imageUrl: 'https://cat.jpg',
    );

    final model = MemorialModel.fromEntity(entity);
    final backToEntity = model.toEntity();

    expect(backToEntity.petName, 'Leo');
    expect(backToEntity.dateOfPassing, '2025-07-20');
  });
}
