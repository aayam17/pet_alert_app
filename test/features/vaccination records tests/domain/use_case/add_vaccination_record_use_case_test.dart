import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pet_alert_app/features/vaccination records/domain/entity/vaccination_record_entity.dart';
import 'package:pet_alert_app/features/vaccination records/domain/use_case/add_vaccination_record_use_case.dart';
import 'package:pet_alert_app/features/vaccination records/domain/repository/vaccination_repository.dart';

class MockVaccinationRepository extends Mock implements VaccinationRepository {}

void main() {
  late MockVaccinationRepository mockRepository;
  late AddVaccinationRecordUseCase useCase;

  setUp(() {
    mockRepository = MockVaccinationRepository();
    useCase = AddVaccinationRecordUseCase(mockRepository);
  });

  test('should call addRecord on repository', () async {
    final record = VaccinationRecordEntity(
      id: '1',
      vaccine: 'Rabies',
      notes: '',
      date: '2025-08-01',
    );

    when(() => mockRepository.addRecord(record)).thenAnswer((_) async {});

    await useCase(record);

    verify(() => mockRepository.addRecord(record)).called(1);
  });
}
