import 'package:hive/hive.dart';
import 'package:pet_alert_app/features/auth/data/model/user_model.dart';

Future<Map<String, String>> headersWithToken() async {
  final userBox = Hive.box<AuthApiModel>('users');
  final token = userBox.values.firstOrNull?.token;

  if (token == null || token.isEmpty) {
    throw Exception("JWT token missing");
  }

  return {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  };
}
