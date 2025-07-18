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

// Lost and Found
import 'package:pet_alert_app/features/lost and found/data/data_source/remote_datasource/lost_and_found_remote_datasource.dart';
import 'package:pet_alert_app/features/lost and found/data/data_source/remote_datasource/lost_and_found_remote_datasource_impl.dart';
import 'package:pet_alert_app/features/lost and found/data/repository/remote_repository/lost_and_found_repository_impl.dart';
import 'package:pet_alert_app/features/lost and found/domian/repository/lost_and_found_repository.dart';
import 'package:pet_alert_app/features/lost and found/domian/use_case/add_lost_and_found_use_case.dart';
import 'package:pet_alert_app/features/lost and found/domian/use_case/delete_lost_and_found_use_case.dart';
import 'package:pet_alert_app/features/lost and found/domian/use_case/get_lost_and_found_use_case.dart';
import 'package:pet_alert_app/features/lost and found/domian/use_case/update_lost_and_found_use_case.dart';
import 'package:pet_alert_app/features/lost and found/presentation/view_model/lost_and_found_cubit.dart';

// Vet Appointments
import 'package:pet_alert_app/features/vet appointments/data/data_source/remote_datasource/vet_appointment_remote_datasource.dart';
import 'package:pet_alert_app/features/vet appointments/data/data_source/remote_datasource/vet_appointment_remote_datasource_impl.dart';
import 'package:pet_alert_app/features/vet appointments/data/repository/remote_repository/vet_appointment_repository_impl.dart';
import 'package:pet_alert_app/features/vet appointments/domain/repository/appointment_repository.dart';
import 'package:pet_alert_app/features/vet appointments/domain/use_case/add_vet_appointment_use_case.dart';
import 'package:pet_alert_app/features/vet appointments/domain/use_case/delete_vet_appointment_use_case.dart';
import 'package:pet_alert_app/features/vet appointments/domain/use_case/get_appointments_use_case.dart';
import 'package:pet_alert_app/features/vet appointments/domain/use_case/update_vet_appointment_use_case.dart';
import 'package:pet_alert_app/features/vet appointments/presentation/view_model/vet_appointment_cubit.dart';

// Vaccination Records
import 'package:pet_alert_app/features/vaccination records/data/data_source/remote_datasource/vaccination_remote_datasource.dart';
import 'package:pet_alert_app/features/vaccination records/data/data_source/remote_datasource/vaccination_remote_datasource_impl.dart';
import 'package:pet_alert_app/features/vaccination records/data/repository/remote_repository/vaccination_repository_impl.dart';
import 'package:pet_alert_app/features/vaccination records/domain/repository/vaccination_repository.dart';
import 'package:pet_alert_app/features/vaccination records/domain/use_case/add_vaccination_record_use_case.dart';
import 'package:pet_alert_app/features/vaccination records/domain/use_case/delete_vaccination_record_use_case.dart';
import 'package:pet_alert_app/features/vaccination records/domain/use_case/get_vaccination_records_use_case.dart';
import 'package:pet_alert_app/features/vaccination records/domain/use_case/update_vaccination_record_use_case.dart';
import 'package:pet_alert_app/features/vaccination records/presentation/view_model/vaccination_cubit.dart';

// Memorials
import 'package:pet_alert_app/features/memorials/data/data_source/remote_datasource/memorial_remote_datasource.dart';
import 'package:pet_alert_app/features/memorials/data/data_source/remote_datasource/memorial_remote_datasource_impl.dart';
import 'package:pet_alert_app/features/memorials/data/repository/remote_repository/memorial_repository_impl.dart';
import 'package:pet_alert_app/features/memorials/domain/repository/memorial_repository.dart';
import 'package:pet_alert_app/features/memorials/domain/use_case/add_memorial_use_case.dart';
import 'package:pet_alert_app/features/memorials/domain/use_case/delete_memorial_use_case.dart';
import 'package:pet_alert_app/features/memorials/domain/use_case/get_memorials_use_case.dart';
import 'package:pet_alert_app/features/memorials/domain/use_case/update_memorial_use_case.dart';
import 'package:pet_alert_app/features/memorials/presentation/view_model/memorial_cubit.dart';

// Community Board
import 'package:pet_alert_app/features/community board/presentation/view_model/community_board_cubit.dart';

final serviceLocator = GetIt.instance;
final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  final userBox = await Hive.openBox<AuthApiModel>('users');
  serviceLocator.registerSingleton<Box<AuthApiModel>>(userBox);
  serviceLocator.registerLazySingleton(() => http.Client());

  // Auth
  serviceLocator.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(serviceLocator()),
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

  // Vet Appointments
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

  // Vaccination Records
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

  // Lost and Found
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

  // Memorials
  serviceLocator.registerLazySingleton<MemorialRemoteDataSource>(
    () => MemorialRemoteDataSourceImpl(serviceLocator()),
  );
  final memorialRepoImpl = MemorialRepositoryImpl(serviceLocator());
  serviceLocator.registerLazySingleton<MemorialRepositoryImpl>(() => memorialRepoImpl);
  serviceLocator.registerLazySingleton<MemorialRepository>(() => memorialRepoImpl);
  serviceLocator.registerLazySingleton(() => GetMemorialsUseCase(serviceLocator()));
  serviceLocator.registerLazySingleton(() => AddMemorialUseCase(serviceLocator()));
  serviceLocator.registerLazySingleton(() => UpdateMemorialUseCase(serviceLocator()));
  serviceLocator.registerLazySingleton(() => DeleteMemorialUseCase(serviceLocator()));
  serviceLocator.registerFactory(() => MemorialCubit(
        getUseCase: serviceLocator(),
        addUseCase: serviceLocator(),
        updateUseCase: serviceLocator(),
        deleteUseCase: serviceLocator(),
      ));

  // Community Board 🧩
  serviceLocator.registerFactory(() => CommunityBoardCubit(
        getLostUseCase: serviceLocator(),
        getMemorialsUseCase: serviceLocator(),
      ));
}
