// lib/services/water_meter_service.dart
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../models/water_meter_model.dart';
import 'api_endpoints.dart';
import '../providers/auth_provider.dart';

class WaterMeterService {
  final Ref? ref;

  WaterMeterService({this.ref});

  Future<Map<String, String>> _getHeaders(Ref ref) async {
    final authState = ref.read(authProvider);
    final token = authState.token;
    
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  // Get all water meter readings
  Future<List<WaterMeterReading>> getReadings(
    Ref ref, {
    int page = 1,
    int perPage = 20,
  }) async {
    try {
      final headers = await _getHeaders(ref);
      final response = await http.get(
        Uri.parse(
            '${ApiEndpoints.waterMeterReadings}?page=$page&per_page=$perPage'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> readingsJson = data['data']['data'] ?? [];
        return readingsJson
            .map((json) => WaterMeterReading.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to load readings: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load readings: $e');
    }
  }

  // Get a single reading by ID
  Future<WaterMeterReading> getReadingById(Ref ref, int id) async {
    try {
      final headers = await _getHeaders(ref);
      final response = await http.get(
        Uri.parse(ApiEndpoints.waterMeterReadingDetail(id)),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return WaterMeterReading.fromJson(data['data']);
      } else {
        throw Exception('Failed to load reading: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load reading: $e');
    }
  }

  // Create a new water meter reading
  Future<WaterMeterReading> createReading(
    Ref ref,
    WaterMeterReadingRequest request,
  ) async {
    try {
      final headers = await _getHeaders(ref);
      final response = await http.post(
        Uri.parse(ApiEndpoints.waterMeterReadings),
        headers: headers,
        body: json.encode(request.toJson()),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = json.decode(response.body);
        return WaterMeterReading.fromJson(data['data']);
      } else {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Failed to create reading');
      }
    } catch (e) {
      throw Exception('Failed to create reading: $e');
    }
  }

  // Update a reading (for verification or editing)
  Future<WaterMeterReading> updateReading(
    Ref ref,
    int id, {
    String? status,
    String? notes,
  }) async {
    try {
      final headers = await _getHeaders(ref);
      final body = <String, dynamic>{};
      if (status != null) body['status'] = status;
      if (notes != null) body['notes'] = notes;

      final response = await http.put(
        Uri.parse(ApiEndpoints.waterMeterReadingDetail(id)),
        headers: headers,
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return WaterMeterReading.fromJson(data['data']);
      } else {
        throw Exception('Failed to update reading: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to update reading: $e');
    }
  }

  // Verify a reading
  Future<WaterMeterReading> verifyReading(Ref ref, int id) async {
    return await updateReading(ref, id, status: 'verified');
  }

  // Delete a reading
  Future<void> deleteReading(Ref ref, int id) async {
    try {
      final headers = await _getHeaders(ref);
      final response = await http.delete(
        Uri.parse(ApiEndpoints.waterMeterReadingDetail(id)),
        headers: headers,
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to delete reading: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to delete reading: $e');
    }
  }
}