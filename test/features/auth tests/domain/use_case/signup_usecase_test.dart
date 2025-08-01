import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pet_alert_app/features/auth/data/model/user_model.dart';
import 'package:pet_alert_app/features/auth/domain/entity/auth_entity.dart';
import 'package:pet_alert_app/features/auth/domain/repository/auth_repository.dart';
import 'package:pet_alert_app/features/auth/domain/use_case/signup_usecase.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late SignupUseCase signupUseCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    signupUseCase = SignupUseCase(mockRepository);
  });

  test('calls repository.signup and returns AuthApiModel', () async {
    final authEntity = AuthEntity(
      name: 'New User',
      email: 'new@email.com',
      password: 'pass123',
    );

    final expectedUser = AuthApiModel(
      email: authEntity.email,
      password: '',
      name: authEntity.name,
      token: 'xyz456',
    );

    when(() => mockRepository.signup(authEntity))
        .thenAnswer((_) async => expectedUser);

    final result = await signupUseCase(authEntity);

    expect(result, expectedUser);
    verify(() => mockRepository.signup(authEntity)).called(1);
  });
}
