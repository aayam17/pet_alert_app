import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

// Auth
import 'package:pet_alert_app/features/auth/data/data_source/local_datasource/auth_local_datasource.dart';
import 'package:pet_alert_app/features/auth/data/data_source/remote_datasource/auth_remote_datasource.dart';
import 'package:pet_alert_app/features/auth/data/model/user_model.dart';
import 'package:pet_alert_app/features/auth/data/repository/auth_repository_impl.dart';
import 'package:pet_alert_app/features/auth/domain/repository/auth_repository.dart';
import 'package:pet_alert_app/features/auth/domain/use_case/login_usecase.dart';
import 'package:pet_alert_app/features/auth/domain/use_case/signup_usecase.dart';

// Vet Appointments
import 'package:pet_alert_app/features/vet%20appointments/data/data_source/remote_datasource/vet_appointment_remote_datasource.dart';
import 'package:pet_alert_app/features/vet%20appointments/data/data_source/remote_datasource/vet_appointment_remote_datasource_impl.dart';
import 'package:pet_alert_app/features/vet%20appointments/data/repository/remote_repository/vet_appointment_repository_impl.dart';
import 'package:pet_alert_app/features/vet%20appointments/domain/repository/appointment_repository.dart';
import 'package:pet_alert_app/features/vet%20appointments/domain/use_case/add_vet_appointment_use_case.dart';
import 'package:pet_alert_app/features/vet%20appointments/domain/use_case/delete_vet_appointment_use_case.dart';
import 'package:pet_alert_app/features/vet%20appointments/domain/use_case/get_appointments_use_case.dart';
import 'package:pet_alert_app/features/vet%20appointments/domain/use_case/update_vet_appointment_use_case.dart';
import 'package:pet_alert_app/features/vet%20appointments/presentation/view_model/vet_appointment_cubit.dart';

final serviceLocator = GetIt.instance;

Future<void> setupServiceLocator() async {
  // ✅ Open Hive box
  final userBox = await Hive.openBox<AuthApiModel>('users');

  // ✅ Register Hive Box
  serviceLocator.registerSingleton<Box<AuthApiModel>>(userBox);

  // ========== AUTH ==========

  // ✅ Local data source
  serviceLocator.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(
      serviceLocator<Box<AuthApiModel>>(),
    ),
  );

  // ✅ Remote data source
  serviceLocator.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      http.Client(),
    ),
  );

  // ✅ Auth repository
  serviceLocator.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      localDataSource: serviceLocator<AuthLocalDataSource>(),
      remoteDataSource: serviceLocator<AuthRemoteDataSource>(),
    ),
  );

  // ✅ Use cases
  serviceLocator.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(serviceLocator<AuthRepository>()),
  );

  serviceLocator.registerLazySingleton<SignupUseCase>(
    () => SignupUseCase(serviceLocator<AuthRepository>()),
  );

  // ========== VET APPOINTMENTS ==========

  // ✅ External HTTP Client
  serviceLocator.registerLazySingleton(() => http.Client());

  // ✅ Remote data source
  serviceLocator.registerLazySingleton<VetAppointmentRemoteDataSource>(
    () => VetAppointmentRemoteDataSourceImpl(serviceLocator<http.Client>()),
  );

  // ✅ Repository
  serviceLocator.registerLazySingleton<AppointmentRepository>(
    () => VetAppointmentRepositoryImpl(serviceLocator<VetAppointmentRemoteDataSource>()),
  );

  // ✅ Use cases
  serviceLocator.registerLazySingleton(
    () => GetAppointmentsUseCase(serviceLocator<AppointmentRepository>()),
  );

  serviceLocator.registerLazySingleton(
    () => AddVetAppointmentUseCase(serviceLocator<AppointmentRepository>()),
  );

  serviceLocator.registerLazySingleton(
    () => UpdateVetAppointmentUseCase(serviceLocator<AppointmentRepository>()),
  );

  serviceLocator.registerLazySingleton(
    () => DeleteVetAppointmentUseCase(serviceLocator<AppointmentRepository>()),
  );

  // ✅ Cubit
  serviceLocator.registerFactory(() => VetAppointmentCubit(
        getUseCase: serviceLocator(),
        addUseCase: serviceLocator(),
        updateUseCase: serviceLocator(),
        deleteUseCase: serviceLocator(),
      ));
}
