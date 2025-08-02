import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';

import 'package:pet_alert_app/features/auth/data/model/user_model.dart';
import 'package:pet_alert_app/features/lost and found/data/dto/lost_and_found_dto.dart';
import 'lost_and_found_remote_datasource.dart';

class LostAndFoundRemoteDataSourceImpl implements LostAndFoundRemoteDataSource {
  final http.Client client;
  late final String baseUrl;

  LostAndFoundRemoteDataSourceImpl(this.client) {
    if (kReleaseMode) {
      baseUrl = 'https://api.petalert.com/api/lostandfound';
    } else {
      if (Platform.isAndroid) {
        baseUrl = 'http://10.0.2.2:3000/api/lostandfound';
      } else if (Platform.isIOS) {
        baseUrl = 'http://192.168.1.90:3000/api/lostandfound';
      } else {
        baseUrl = 'http://localhost:3000/api/lostandfound';
      }
    }
  }

  Future<Map<String, String>> _headersWithToken() async {
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

  @override
  Future<List<LostAndFoundDto>> fetchEntries() async {
    final headers = await _headersWithToken();
    final response = await client.get(Uri.parse(baseUrl), headers: headers);

    if (response.statusCode != 200) {
      throw Exception("Failed to load lost and found entries: ${response.body}");
    }

    final List data = json.decode(response.body);
    return data.map((e) => LostAndFoundDto.fromJson(e)).toList();
  }

  @override
  Future<void> addEntry(LostAndFoundDto dto) async {
    final headers = await _headersWithToken();
    final response = await client.post(
      Uri.parse(baseUrl),
      headers: headers,
      body: json.encode(dto.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception("Failed to add lost and found entry: ${response.body}");
    }
  }

  @override
  Future<void> updateEntry(String id, LostAndFoundDto dto) async {
    final headers = await _headersWithToken();
    final response = await client.put(
      Uri.parse('$baseUrl/$id'),
      headers: headers,
      body: json.encode(dto.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to update lost and found entry: ${response.body}");
    }
  }

  @override
  Future<void> deleteEntry(String id) async {
    final headers = await _headersWithToken();
    final response = await client.delete(
      Uri.parse('$baseUrl/$id'),
      headers: headers,
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to delete lost and found entry: ${response.body}");
    }
  }
}
