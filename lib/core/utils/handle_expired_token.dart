import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:pet_alert_app/features/auth/data/model/user_model.dart';

void handleExpiredToken(BuildContext context) async {
  final box = Hive.box<AuthApiModel>('users');
  await box.clear();

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Session expired. Please login again.')),
  );

  Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
}
