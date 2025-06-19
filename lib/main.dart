import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_alert_app/app/app.dart';
import 'package:pet_alert_app/app/constant/hive/hive_config.dart';
import 'package:pet_alert_app/features/splash_screen/presentation/view_model/splash_view_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initHive();

  runApp(
    BlocProvider(
      create: (_) => SplashViewModel(),
      child: const MyApp(),
    ),
  );
}
