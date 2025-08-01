import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pet_alert_app/features/vaccination records/domain/entity/vaccination_record_entity.dart';
import 'package:pet_alert_app/features/vaccination records/domain/use_case/update_vaccination_record_use_case.dart';
import 'package:pet_alert_app/features/vaccination records/domain/repository/vaccination_repository.dart';

class MockVaccinationRepository extends Mock implements VaccinationRepository {}

void main() {
  late MockVaccinationRepository mockRepository;
  late UpdateVaccinationRecordUseCase useCase;

  setUp(() {
    mockRepository = MockVaccinationRepository();
    useCase = UpdateVaccinationRecordUseCase(mockRepository);
  });

  test('should call updateRecord on repository', () async {
    final record = VaccinationRecordEntity(
      id: '1',
      vaccine: 'Rabies',
      notes: 'Updated',
      date: '2025-08-01',
    );

    when(() => mockRepository.updateRecord('1', record)).thenAnswer((_) async {});

    await useCase('1', record);

    verify(() => mockRepository.updateRecord('1', record)).called(1);
  });
}
