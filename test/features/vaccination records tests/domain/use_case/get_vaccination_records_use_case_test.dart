import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pet_alert_app/features/vaccination records/domain/entity/vaccination_record_entity.dart';
import 'package:pet_alert_app/features/vaccination records/domain/use_case/get_vaccination_records_use_case.dart';
import 'package:pet_alert_app/features/vaccination records/domain/repository/vaccination_repository.dart';

class MockVaccinationRepository extends Mock implements VaccinationRepository {}

void main() {
  late MockVaccinationRepository mockRepository;
  late GetVaccinationRecordsUseCase useCase;

  setUp(() {
    mockRepository = MockVaccinationRepository();
    useCase = GetVaccinationRecordsUseCase(mockRepository);
  });

  test('should return list of records from repository', () async {
    final records = [
      VaccinationRecordEntity(id: '1', vaccine: 'Rabies', notes: 'Annual', date: '2025-08-01')
    ];

    when(() => mockRepository.getRecords()).thenAnswer((_) async => records);

    final result = await useCase();

    expect(result, records);
    verify(() => mockRepository.getRecords()).called(1);
  });
}
