import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:pet_alert_app/features/auth/data/data_source/local_datasource/auth_local_datasource.dart';
import 'package:pet_alert_app/features/auth/data/data_source/remote_datasource/auth_remote_datasource.dart';
import 'package:pet_alert_app/features/auth/data/model/user_model.dart';
import 'package:pet_alert_app/features/auth/data/repository/auth_repository_impl.dart';
import 'package:pet_alert_app/features/auth/domain/repository/auth_repository.dart';
import 'package:pet_alert_app/features/auth/domain/use_case/login_usecase.dart';
import 'package:pet_alert_app/features/auth/domain/use_case/signup_usecase.dart';

final serviceLocator = GetIt.instance;

Future<void> setupServiceLocator() async {
  //pen Hive box
  final userBox = await Hive.openBox<AuthApiModel>('users');

  //Register Hive Box
  serviceLocator.registerSingleton<Box<AuthApiModel>>(userBox);

  // ✅ Register local data source
  serviceLocator.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(
      serviceLocator<Box<AuthApiModel>>(),
    ),
  );

  // Register remote data source
  serviceLocator.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      http.Client(),
    ),
  );

  //Register repository implementation
  serviceLocator.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      localDataSource: serviceLocator<AuthLocalDataSource>(),
      remoteDataSource: serviceLocator<AuthRemoteDataSource>(),
    ),
  );

  //Register use cases
  serviceLocator.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(serviceLocator<AuthRepository>()),
  );

  serviceLocator.registerLazySingleton<SignupUseCase>(
    () => SignupUseCase(serviceLocator<AuthRepository>()),
  );
}
