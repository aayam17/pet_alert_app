import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:pet_alert_app/features/auth/data/data_source/local_datasource/auth_local_datasource.dart';
import 'package:pet_alert_app/features/auth/data/model/user_model.dart';
import 'package:pet_alert_app/features/auth/data/repository/auth_repository_impl.dart';
import 'package:pet_alert_app/features/auth/domain/repository/auth_repository.dart';
import 'package:pet_alert_app/features/auth/domain/use_case/login_usecase.dart';
import 'package:pet_alert_app/features/auth/domain/use_case/signup_usecase.dart';

final serviceLocator = GetIt.instance;

Future<void> setupServiceLocator() async {
  final userBox = await Hive.openBox<AuthApiModel>('users');

  serviceLocator.registerSingleton<Box<AuthApiModel>>(userBox);

  serviceLocator.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(serviceLocator<Box<AuthApiModel>>()),
  );

  serviceLocator.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(serviceLocator()),
  );

  serviceLocator.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(serviceLocator()),
  );

  serviceLocator.registerLazySingleton<SignupUseCase>(
    () => SignupUseCase(serviceLocator()),
  );
}
