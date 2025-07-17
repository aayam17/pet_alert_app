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
import 'package:pet_alert_app/features/lost%20and%20found/data/repository/remote_repository/lost_and_found_repository_impl.dart';

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

// Vaccination Records
import 'package:pet_alert_app/features/vaccination%20records/data/data_source/remote_datasource/vaccination_remote_datasource.dart';
import 'package:pet_alert_app/features/vaccination%20records/data/data_source/remote_datasource/vaccination_remote_datasource_impl.dart';
import 'package:pet_alert_app/features/vaccination%20records/data/repository/remote_repository/vaccination_repository_impl.dart';
import 'package:pet_alert_app/features/vaccination%20records/domain/repository/vaccination_repository.dart';
import 'package:pet_alert_app/features/vaccination%20records/domain/use_case/add_vaccination_record_use_case.dart';
import 'package:pet_alert_app/features/vaccination%20records/domain/use_case/delete_vaccination_record_use_case.dart';
import 'package:pet_alert_app/features/vaccination%20records/domain/use_case/get_vaccination_records_use_case.dart';
import 'package:pet_alert_app/features/vaccination%20records/domain/use_case/update_vaccination_record_use_case.dart';
import 'package:pet_alert_app/features/vaccination%20records/presentation/view_model/vaccination_cubit.dart';

// Lost and Found
import 'package:pet_alert_app/features/lost%20and%20found/data/data_source/remote_datasource/lost_and_found_remote_datasource.dart';
import 'package:pet_alert_app/features/lost%20and%20found/data/data_source/remote_datasource/lost_and_found_remote_datasource_impl.dart';
import 'package:pet_alert_app/features/lost%20and%20found/domian/repository/lost_and_found_repository.dart';
import 'package:pet_alert_app/features/lost%20and%20found/domian/use_case/add_lost_and_found_use_case.dart';
import 'package:pet_alert_app/features/lost%20and%20found/domian/use_case/delete_lost_and_found_use_case.dart';
import 'package:pet_alert_app/features/lost%20and%20found/domian/use_case/get_lost_and_found_use_case.dart';
import 'package:pet_alert_app/features/lost%20and%20found/domian/use_case/update_lost_and_found_use_case.dart';
import 'package:pet_alert_app/features/lost%20and%20found/presentation/view_model/lost_and_found_cubit.dart';

final serviceLocator = GetIt.instance;

Future<void> setupServiceLocator() async {
  final userBox = await Hive.openBox<AuthApiModel>('users');
  serviceLocator.registerSingleton<Box<AuthApiModel>>(userBox);

  serviceLocator.registerLazySingleton(() => http.Client());

  // AUTH
  serviceLocator.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(serviceLocator<Box<AuthApiModel>>()),
  );
  serviceLocator.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(serviceLocator()),
  );
  serviceLocator.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      localDataSource: serviceLocator(),
      remoteDataSource: serviceLocator(),
    ),
  );
  serviceLocator.registerLazySingleton(() => LoginUseCase(serviceLocator()));
  serviceLocator.registerLazySingleton(() => SignupUseCase(serviceLocator()));

  // VET APPOINTMENTS
  serviceLocator.registerLazySingleton<VetAppointmentRemoteDataSource>(
    () => VetAppointmentRemoteDataSourceImpl(serviceLocator()),
  );
  serviceLocator.registerLazySingleton<AppointmentRepository>(
    () => VetAppointmentRepositoryImpl(serviceLocator()),
  );
  serviceLocator.registerLazySingleton(() => GetAppointmentsUseCase(serviceLocator()));
  serviceLocator.registerLazySingleton(() => AddVetAppointmentUseCase(serviceLocator()));
  serviceLocator.registerLazySingleton(() => UpdateVetAppointmentUseCase(serviceLocator()));
  serviceLocator.registerLazySingleton(() => DeleteVetAppointmentUseCase(serviceLocator()));
  serviceLocator.registerFactory(() => VetAppointmentCubit(
        getUseCase: serviceLocator(),
        addUseCase: serviceLocator(),
        updateUseCase: serviceLocator(),
        deleteUseCase: serviceLocator(),
      ));

  // VACCINATION RECORDS
  serviceLocator.registerLazySingleton<VaccinationRemoteDataSource>(
    () => VaccinationRemoteDataSourceImpl(serviceLocator()),
  );
  serviceLocator.registerLazySingleton<VaccinationRepository>(
    () => VaccinationRepositoryImpl(serviceLocator()),
  );
  serviceLocator.registerLazySingleton(() => GetVaccinationRecordsUseCase(serviceLocator()));
  serviceLocator.registerLazySingleton(() => AddVaccinationRecordUseCase(serviceLocator()));
  serviceLocator.registerLazySingleton(() => UpdateVaccinationRecordUseCase(serviceLocator()));
  serviceLocator.registerLazySingleton(() => DeleteVaccinationRecordUseCase(serviceLocator()));
  serviceLocator.registerFactory(() => VaccinationCubit(
        getUseCase: serviceLocator(),
        addUseCase: serviceLocator(),
        updateUseCase: serviceLocator(),
        deleteUseCase: serviceLocator(),
      ));

  // LOST AND FOUND 🆕
  serviceLocator.registerLazySingleton<LostAndFoundRemoteDataSource>(
    () => LostAndFoundRemoteDataSourceImpl(serviceLocator()),
  );
  serviceLocator.registerLazySingleton<LostAndFoundRepository>(
    () => LostAndFoundRepositoryImpl(serviceLocator()),
  );
  serviceLocator.registerLazySingleton(() => GetLostAndFoundUseCase(serviceLocator()));
  serviceLocator.registerLazySingleton(() => AddLostAndFoundUseCase(serviceLocator()));
  serviceLocator.registerLazySingleton(() => UpdateLostAndFoundUseCase(serviceLocator()));
  serviceLocator.registerLazySingleton(() => DeleteLostAndFoundUseCase(serviceLocator()));
  serviceLocator.registerFactory(() => LostAndFoundCubit(
        getUseCase: serviceLocator(),
        addUseCase: serviceLocator(),
        updateUseCase: serviceLocator(),
        deleteUseCase: serviceLocator(),
      ));
}
