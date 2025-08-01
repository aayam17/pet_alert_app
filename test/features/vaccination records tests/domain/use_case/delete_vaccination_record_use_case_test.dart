import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pet_alert_app/features/vaccination records/domain/use_case/delete_vaccination_record_use_case.dart';
import 'package:pet_alert_app/features/vaccination records/domain/repository/vaccination_repository.dart';

class MockVaccinationRepository extends Mock implements VaccinationRepository {}

void main() {
  late MockVaccinationRepository mockRepository;
  late DeleteVaccinationRecordUseCase useCase;

  setUp(() {
    mockRepository = MockVaccinationRepository();
    useCase = DeleteVaccinationRecordUseCase(mockRepository);
  });

  test('should call deleteRecord on repository', () async {
    when(() => mockRepository.deleteRecord('1')).thenAnswer((_) async {});

    await useCase('1');

    verify(() => mockRepository.deleteRecord('1')).called(1);
  });
}
