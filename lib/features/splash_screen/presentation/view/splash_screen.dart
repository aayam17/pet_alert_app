// lib/features/splash/presentation/view/splash_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_alert_app/features/splash_screen/presentation/view_model/splash_view_model.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Call SplashViewModel logic after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SplashViewModel>().init(context);
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo_pet.png',
              width: 180,
              height: 180,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 30),
            const CircularProgressIndicator(
              color: Colors.black,
              strokeWidth: 2.5,
            ),
            const SizedBox(height: 16),
            const Text(
              'Loading PetAlert...',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            )
          ],
        ),
      ),
    );
  }
}
