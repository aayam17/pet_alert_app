import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pet_alert_app/features/auth/data/model/user_model.dart';
import 'package:pet_alert_app/features/auth/domain/repository/auth_repository.dart';
import 'package:pet_alert_app/features/auth/domain/use_case/login_usecase.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late LoginUseCase loginUseCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    loginUseCase = LoginUseCase(mockRepository);
  });

  test('calls repository.login and returns AuthApiModel', () async {
    const email = 'test@email.com';
    const password = 'secret123';

    final expectedUser = AuthApiModel(
      email: email,
      password: '',
      name: 'Test User',
      token: 'abc123',
    );

    when(() => mockRepository.login(email, password))
        .thenAnswer((_) async => expectedUser);

    final result = await loginUseCase(email, password);

    expect(result, expectedUser);
    verify(() => mockRepository.login(email, password)).called(1);
  });
}
