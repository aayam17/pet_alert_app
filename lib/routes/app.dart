import 'package:flutter/material.dart';
import 'package:pet_alert_app/themes/theme.dart';
import 'package:pet_alert_app/views/dashboard.dart';
import 'package:pet_alert_app/views/login_page.dart';
import 'package:pet_alert_app/views/signup_page.dart';
import 'package:pet_alert_app/views/welcome_page.dart';
import 'package:pet_alert_app/views/splash_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PetAlert',
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
