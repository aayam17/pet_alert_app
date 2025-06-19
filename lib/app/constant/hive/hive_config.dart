import 'package:hive_flutter/hive_flutter.dart';
import 'package:pet_alert_app/features/auth/data/model/user_model.dart';

Future<void> initHive() async {
  await Hive.initFlutter();
  Hive.registerAdapter(AuthApiModelAdapter());
  await Hive.openBox<AuthApiModel>('users');
}
