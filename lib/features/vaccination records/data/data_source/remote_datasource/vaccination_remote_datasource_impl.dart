// data/data_source/remote_datasource/vaccination_remote_datasource_impl.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import 'package:pet_alert_app/features/auth/data/model/user_model.dart';

import '../../dto/vaccination_record_dto.dart';
import 'vaccination_remote_datasource.dart';

class VaccinationRemoteDataSourceImpl implements VaccinationRemoteDataSource {
  final http.Client client;
  final String baseUrl = 'http://127.0.0.1:3000/api/vaccinationrecords';


  VaccinationRemoteDataSourceImpl(this.client);

  Future<Map<String, String>> _headersWithToken() async {
    final userBox = Hive.box<AuthApiModel>('users');
    final user = userBox.values.firstOrNull;
    final token = user?.token;
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
      throw Exception("Failed to load vaccination records");
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
      throw Exception("Failed to add vaccination record");
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
      throw Exception("Failed to update vaccination record");
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
      throw Exception("Failed to delete vaccination record");
    }
  }
}
