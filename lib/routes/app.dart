import 'package:flutter/material.dart';
import 'package:pet_alert_app/views/dashboard.dart';
import 'package:pet_alert_app/views/login_page.dart';
import 'package:pet_alert_app/views/signup_page.dart';
import 'package:pet_alert_app/views/welcome_page.dart';
import 'package:pet_alert_app/views/splash_screen.dart'; // 👈 Make sure to create and import this

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PetAlert',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const SplashScreen(), 
      debugShowCheckedModeBanner: false,
    );
  }
}
