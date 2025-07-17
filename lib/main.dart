import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:pet_alert_app/app/app.dart';
import 'package:pet_alert_app/app/constant/hive/hive_config.dart';
import 'package:pet_alert_app/app/service_locator/service_locator.dart';

// Cubits
import 'package:pet_alert_app/features/splash_screen/presentation/view_model/splash_view_model.dart';
import 'package:pet_alert_app/features/pet%20profile/presentation/bloc/pet_profile_cubit.dart';
import 'package:pet_alert_app/features/vaccination%20records/presentation/view_model/vaccination_cubit.dart';
import 'package:pet_alert_app/features/vet%20appointments/presentation/view_model/vet_appointment_cubit.dart';
import 'package:pet_alert_app/features/lost%20and%20found/presentation/view_model/lost_and_found_cubit.dart';

// Hive Models
import 'package:pet_alert_app/features/auth/data/model/user_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  // Register Hive adapters
  await initHive();

  // Register all dependencies
  await setupServiceLocator();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => SplashViewModel()),
        BlocProvider(create: (_) => PetProfileCubit()),

        // ✅ Vet Appointments
        BlocProvider(create: (_) => serviceLocator<VetAppointmentCubit>()),

        // ✅ Vaccination Records
        BlocProvider(create: (_) => serviceLocator<VaccinationCubit>()),

        // ✅ Lost and Found
        BlocProvider(create: (_) => serviceLocator<LostAndFoundCubit>()),
      ],
      child: const MyApp(),
    ),
  );
}
