import 'package:flutter/material.dart';
import 'package:pet_alert_app/app/theme/theme.dart';
import 'package:pet_alert_app/features/splash_screen/presentation/view/splash_screen.dart';

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
