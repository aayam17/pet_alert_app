import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pet_alert_app/features/memorials/domain/entity/memorial_entity.dart';
import 'package:pet_alert_app/features/memorials/domain/use_case/get_memorials_use_case.dart';
import 'package:pet_alert_app/features/memorials/domain/use_case/add_memorial_use_case.dart';
import 'package:pet_alert_app/features/memorials/domain/use_case/update_memorial_use_case.dart';
import 'package:pet_alert_app/features/memorials/domain/use_case/delete_memorial_use_case.dart';
import 'package:pet_alert_app/features/memorials/presentation/view_model/memorial_cubit.dart';
import 'package:pet_alert_app/features/memorials/presentation/view_model/memorial_state.dart';

class MockGetMemorialsUseCase extends Mock implements GetMemorialsUseCase {}
class MockAddMemorialUseCase extends Mock implements AddMemorialUseCase {}
class MockUpdateMemorialUseCase extends Mock implements UpdateMemorialUseCase {}
class MockDeleteMemorialUseCase extends Mock implements DeleteMemorialUseCase {}

void main() {
  late MemorialCubit cubit;
  late MockGetMemorialsUseCase mockGet;
  late MockAddMemorialUseCase mockAdd;
  late MockUpdateMemorialUseCase mockUpdate;
  late MockDeleteMemorialUseCase mockDelete;

  setUp(() {
    mockGet = MockGetMemorialsUseCase();
    mockAdd = MockAddMemorialUseCase();
    mockUpdate = MockUpdateMemorialUseCase();
    mockDelete = MockDeleteMemorialUseCase();

    cubit = MemorialCubit(
      getUseCase: mockGet,
      addUseCase: mockAdd,
      updateUseCase: mockUpdate,
      deleteUseCase: mockDelete,
    );
  });

  test('emits [MemorialLoading, MemorialLoaded] when loadMemorials succeeds', () async {
    final memorials = [
      MemorialEntity(
        id: '1',
        petName: 'Tommy',
        message: 'Rest in peace',
        dateOfPassing: '2025-08-01',
        imageUrl: '',
      ),
    ];

    when(() => mockGet()).thenAnswer((_) async => memorials);

    expectLater(
      cubit.stream,
      emitsInOrder([
        isA<MemorialLoading>(),
        isA<MemorialLoaded>().having((s) => s.memorials.length, 'length', 1),
      ]),
    );

    cubit.loadMemorials();
  });
}
