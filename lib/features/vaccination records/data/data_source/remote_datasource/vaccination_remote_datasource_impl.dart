// data/data_source/remote_datasource/vaccination_remote_datasource_impl.dart

import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import 'package:pet_alert_app/features/auth/data/model/user_model.dart';

import '../../dto/vaccination_record_dto.dart';
import 'vaccination_remote_datasource.dart';

class VaccinationRemoteDataSourceImpl implements VaccinationRemoteDataSource {
  final http.Client client;
  late final String baseUrl;

  VaccinationRemoteDataSourceImpl(this.client) {
    if (kReleaseMode) {
      baseUrl = 'https://api.petalert.com/api/vaccinationrecords'; // Your future prod URL
    } else {
      if (Platform.isAndroid) {
        baseUrl = 'http://10.0.2.2:3000/api/vaccinationrecords';
      } else if (Platform.isIOS) {
        baseUrl = 'http://192.168.1.90:3000/api/vaccinationrecords'; // Your Mac's IP
      } else {
        baseUrl = 'http://localhost:3000/api/vaccinationrecords';
      }
    }
  }

  Future<Map<String, String>> _headersWithToken() async {
    final userBox = Hive.box<AuthApiModel>('users');
    final token = userBox.values.firstOrNull?.token;
    if (token == null) throw Exception("JWT token missing");
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  @override
  Future<List<VaccinationRecordDto>> fetchRecords() async {
    final headers = await _headersWithToken();
    final response = await client.get(Uri.parse(baseUrl), headers: headers);

    if (response.statusCode != 200) {
      throw Exception("Failed to load vaccination records: ${response.body}");
    }

    final List data = json.decode(response.body);
    return data.map((e) => VaccinationRecordDto.fromJson(e)).toList();
  }

  @override
  Future<void> addRecord(VaccinationRecordDto dto) async {
    final headers = await _headersWithToken();
    final response = await client.post(
      Uri.parse(baseUrl),
      headers: headers,
      body: json.encode(dto.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception("Failed to add vaccination record: ${response.body}");
    }
  }

  @override
  Future<void> updateRecord(String id, VaccinationRecordDto dto) async {
    final headers = await _headersWithToken();
    final response = await client.put(
      Uri.parse('$baseUrl/$id'),
      headers: headers,
      body: json.encode(dto.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to update vaccination record: ${response.body}");
    }
  }

  @override
  Future<void> deleteRecord(String id) async {
    final headers = await _headersWithToken();
    final response = await client.delete(
      Uri.parse('$baseUrl/$id'),
      headers: headers,
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to delete vaccination record: ${response.body}");
    }
  }
}
