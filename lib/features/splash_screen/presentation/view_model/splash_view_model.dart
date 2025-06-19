// lib/features/splash/presentation/view_model/splash_view_model.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_alert_app/app/service_locator/service_locator.dart';
import 'package:pet_alert_app/features/auth/presentation/view/login_page.dart';
import 'package:pet_alert_app/features/auth/presentation/view_model/login/login_bloc.dart';

class SplashViewModel extends Cubit<void> {
  SplashViewModel() : super(null);

  Future<void> init(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 2));
    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (_) => LoginBloc(loginUseCase: serviceLocator()),
            child: const LoginPage(),
          ),
        ),
      );
    }
  }
}
