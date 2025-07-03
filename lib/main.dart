import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_alert_app/app/app.dart';
import 'package:pet_alert_app/app/constant/hive/hive_config.dart';
import 'package:pet_alert_app/app/service_locator/service_locator.dart';
import 'package:pet_alert_app/features/splash_screen/presentation/view_model/splash_view_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  //Clear old data once if migrating Hive model
  await Hive.deleteBoxFromDisk('users');

  await initHive();
  await setupServiceLocator();

  runApp(
    BlocProvider(
      create: (_) => SplashViewModel(),
      child: const MyApp(),
    ),
  );
}
