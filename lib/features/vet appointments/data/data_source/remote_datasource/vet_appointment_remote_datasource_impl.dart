import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../dto/vet_appointment_dto.dart';
import 'vet_appointment_remote_datasource.dart';
import 'package:hive/hive.dart';
import 'package:pet_alert_app/features/auth/data/model/user_model.dart';

class VetAppointmentRemoteDataSourceImpl implements VetAppointmentRemoteDataSource {
  final http.Client client;
  late final String baseUrl;

  VetAppointmentRemoteDataSourceImpl(this.client) {
    if (kReleaseMode) {
      baseUrl = 'https://api.petalert.com/api/vetappointments'; // Future prod URL
    } else {
      if (Platform.isAndroid) {
        baseUrl = 'http://10.0.2.2:3000/api/vetappointments';
      } else if (Platform.isIOS) {
        baseUrl = 'http://192.168.1.90:3000/api/vetappointments'; // ← your Mac IP here
      } else {
        baseUrl = 'http://localhost:3000/api/vetappointments';
      }
    }
  }

  Future<Map<String, String>> _headersWithToken() async {
    final box = Hive.box<AuthApiModel>('users');
    final token = box.values.firstOrNull?.token;
    if (token == null) throw Exception('JWT Token not found');
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  @override
  Future<List<VetAppointmentDto>> fetchAppointments() async {
    final headers = await _headersWithToken();
    final response = await client.get(Uri.parse(baseUrl), headers: headers);
    if (response.statusCode != 200) {
      throw Exception('Failed to fetch appointments: ${response.body}');
    }

    final List data = json.decode(response.body);
    return data.map((e) => VetAppointmentDto.fromJson(e)).toList();
  }

  @override
  Future<void> addAppointment(VetAppointmentDto dto) async {
    final headers = await _headersWithToken();
    final response = await client.post(
      Uri.parse(baseUrl),
      headers: headers,
      body: json.encode(dto.toJson()),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to add appointment: ${response.body}');
    }
  }

  @override
  Future<void> updateAppointment(String id, VetAppointmentDto dto) async {
    final headers = await _headersWithToken();
    final response = await client.put(
      Uri.parse('$baseUrl/$id'),
      headers: headers,
      body: json.encode(dto.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update appointment: ${response.body}');
    }
  }

  @override
  Future<void> deleteAppointment(String id) async {
    final headers = await _headersWithToken();
    final response = await client.delete(Uri.parse('$baseUrl/$id'), headers: headers);
    if (response.statusCode != 200) {
      throw Exception('Failed to delete appointment: ${response.body}');
    }
  }
}
