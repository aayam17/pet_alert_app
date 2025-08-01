import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pet_alert_app/features/lost%20and%20found/domian/entity/lost_and_found_entity.dart';
import 'package:pet_alert_app/features/lost%20and%20found/domian/use_case/add_lost_and_found_use_case.dart';
import 'package:pet_alert_app/features/lost%20and%20found/domian/use_case/delete_lost_and_found_use_case.dart';
import 'package:pet_alert_app/features/lost%20and%20found/domian/use_case/get_lost_and_found_use_case.dart';
import 'package:pet_alert_app/features/lost%20and%20found/domian/use_case/update_lost_and_found_use_case.dart';
import 'package:pet_alert_app/features/lost%20and%20found/presentation/view_model/lost_and_found_cubit.dart';
import 'package:pet_alert_app/features/lost%20and%20found/presentation/view_model/lost_and_found_state.dart';

class MockGetLostAndFoundUseCase extends Mock implements GetLostAndFoundUseCase {}

class MockAddLostAndFoundUseCase extends Mock implements AddLostAndFoundUseCase {}

class MockUpdateLostAndFoundUseCase extends Mock implements UpdateLostAndFoundUseCase {}

class MockDeleteLostAndFoundUseCase extends Mock implements DeleteLostAndFoundUseCase {}

void main() {
  late LostAndFoundCubit cubit;
  late MockGetLostAndFoundUseCase mockGetUseCase;
  late MockAddLostAndFoundUseCase mockAddUseCase;
  late MockUpdateLostAndFoundUseCase mockUpdateUseCase;
  late MockDeleteLostAndFoundUseCase mockDeleteUseCase;

  setUp(() {
    mockGetUseCase = MockGetLostAndFoundUseCase();
    mockAddUseCase = MockAddLostAndFoundUseCase();
    mockUpdateUseCase = MockUpdateLostAndFoundUseCase();
    mockDeleteUseCase = MockDeleteLostAndFoundUseCase();

    cubit = LostAndFoundCubit(
      getUseCase: mockGetUseCase,
      addUseCase: mockAddUseCase,
      updateUseCase: mockUpdateUseCase,
      deleteUseCase: mockDeleteUseCase,
    );
  });

  test('emits [Loading, Loaded] when loadEntries succeeds', () async {
    final items = [
      LostAndFoundEntity(
        id: '1',
        type: 'Lost',
        description: 'Lost Dog',
        location: 'Park',
        date: '2025-08-01',
        time: '10:00 AM',
        contactInfo: 'example@test.com',
      )
    ];

    when(() => mockGetUseCase()).thenAnswer((_) async => items);

    expectLater(
      cubit.stream,
      emitsInOrder([
        isA<LostAndFoundLoading>(),
        isA<LostAndFoundLoaded>().having((s) => s.entries.length, 'length', 1),
      ]),
    );

    cubit.loadEntries();
  });
}
