import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../model/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthApiModel> login(String email, String password);
  Future<AuthApiModel> signup(String name, String email, String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final http.Client client;

  AuthRemoteDataSourceImpl(this.client);

  final String _baseUrl = 'http://127.0.0.1:3000/api/auth';

  @override
  Future<AuthApiModel> login(String email, String password) async {
    final response = await client.post(
      Uri.parse('$_baseUrl/login'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    print('LOGIN RESPONSE: ${response.statusCode}');
    print('LOGIN BODY: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      return AuthApiModel.fromJson(jsonDecode(response.body));
    } else {
      Map<String, dynamic> body;
      try {
        body = jsonDecode(response.body);
      } catch (e) {
        print('Non-JSON error response: ${response.body}');
        throw Exception('Login failed. Server returned non-JSON data.');
      }
      final errorMessage = body['message'] ?? 'Failed to login';
      throw Exception(errorMessage);
    }
  }

  @override
  Future<AuthApiModel> signup(String name, String email, String password) async {
    final response = await client.post(
      Uri.parse('$_baseUrl/register'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'username': name,
        'email': email,
        'password': password,
      }),
    );

    print('SIGNUP RESPONSE: ${response.statusCode}');
    print('SIGNUP BODY: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      return AuthApiModel.fromJson(jsonDecode(response.body));
    } else {
      Map<String, dynamic> body;
      try {
        body = jsonDecode(response.body);
      } catch (e) {
        print('Non-JSON error response: ${response.body}');
        throw Exception('Signup failed. Server returned non-JSON data.');
      }
      final errorMessage = body['message'] ?? 'Failed to signup';
      throw Exception(errorMessage);
    }
  }
}
