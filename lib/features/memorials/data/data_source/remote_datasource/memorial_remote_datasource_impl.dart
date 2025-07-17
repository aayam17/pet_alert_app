import 'dart:convert';
import 'dart:io';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

import 'package:pet_alert_app/features/auth/data/model/user_model.dart';
import 'package:pet_alert_app/features/memorials/data/dto/memorial_dto.dart';
import 'memorial_remote_datasource.dart';

class MemorialRemoteDataSourceImpl implements MemorialRemoteDataSource {
  final http.Client client;
  final String baseUrl = 'http://127.0.0.1:3000/api/memorials';
  final String uploadUrl = 'http://127.0.0.1:3000/api/upload';

  MemorialRemoteDataSourceImpl(this.client);

  Future<Map<String, String>> _headersWithToken() async {
    final userBox = Hive.box<AuthApiModel>('users');
    final user = userBox.values.firstOrNull;
    final token = user?.token;

    if (token == null || token.isEmpty) throw Exception("JWT token missing");

    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  @override
  Future<List<MemorialDto>> fetchMemorials() async {
    final headers = await _headersWithToken();
    final response = await client.get(Uri.parse(baseUrl), headers: headers);

    if (response.statusCode != 200) {
      throw Exception("Failed to load memorials");
    }

    final List data = json.decode(response.body);
    return data.map((e) => MemorialDto.fromJson(e)).toList();
  }

  @override
  Future<void> addMemorial(MemorialDto dto) async {
    final headers = await _headersWithToken();
    final response = await client.post(
      Uri.parse(baseUrl),
      headers: headers,
      body: json.encode(dto.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception("Failed to add memorial");
    }
  }

  @override
  Future<void> updateMemorial(String id, MemorialDto dto) async {
    final headers = await _headersWithToken();
    final response = await client.put(
      Uri.parse('$baseUrl/$id'),
      headers: headers,
      body: json.encode(dto.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to update memorial");
    }
  }

  @override
  Future<void> deleteMemorial(String id) async {
    final headers = await _headersWithToken();
    final response = await client.delete(
      Uri.parse('$baseUrl/$id'),
      headers: headers,
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to delete memorial");
    }
  }

  @override
  Future<String> uploadImage(String filePath) async {
    final userBox = Hive.box<AuthApiModel>('users');
    final user = userBox.values.firstOrNull;
    final token = user?.token;

    if (token == null || token.isEmpty) throw Exception("JWT token missing");

    final uri = Uri.parse(uploadUrl);
    final request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $token'
      ..files.add(await http.MultipartFile.fromPath('file', filePath));

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode != 200) {
      throw Exception("Image upload failed");
    }

    final body = json.decode(response.body);
    return body['fileUrl'];
  }
}
