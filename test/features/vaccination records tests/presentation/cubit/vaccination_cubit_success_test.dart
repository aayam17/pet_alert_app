import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pet_alert_app/features/vaccination records/domain/use_case/add_vaccination_record_use_case.dart';
import 'package:pet_alert_app/features/vaccination records/domain/use_case/delete_vaccination_record_use_case.dart';
import 'package:pet_alert_app/features/vaccination records/domain/use_case/get_vaccination_records_use_case.dart';
import 'package:pet_alert_app/features/vaccination records/domain/use_case/update_vaccination_record_use_case.dart';
import 'package:pet_alert_app/features/vaccination records/domain/entity/vaccination_record_entity.dart';
import 'package:pet_alert_app/features/vaccination records/presentation/view_model/vaccination_cubit.dart';
import 'package:pet_alert_app/features/vaccination records/presentation/view_model/vaccination_state.dart';

class MockGetUseCase extends Mock implements GetVaccinationRecordsUseCase {}
class DummyAdd extends Mock implements AddVaccinationRecordUseCase {}
class DummyUpdate extends Mock implements UpdateVaccinationRecordUseCase {}
class DummyDelete extends Mock implements DeleteVaccinationRecordUseCase {}

void main() {
  group('VaccinationCubit Success', () {
    late MockGetUseCase mockGet;

    setUp(() {
      mockGet = MockGetUseCase();
    });

    blocTest<VaccinationCubit, VaccinationState>(
      'emits [Loading, Loaded] when loadRecords is called',
      build: () {
        when(() => mockGet()).thenAnswer((_) async => [
          VaccinationRecordEntity(
            id: '1',
            vaccine: 'Rabies',
            notes: '',
            date: '2025-08-01',
          )
        ]);
        return VaccinationCubit(
          getUseCase: mockGet,
          addUseCase: DummyAdd(),
          updateUseCase: DummyUpdate(),
          deleteUseCase: DummyDelete(),
        );
      },
      act: (cubit) => cubit.loadRecords(),
      expect: () => [
        isA<VaccinationLoading>(),
        isA<VaccinationLoaded>(),
      ],
    );
  });
}
