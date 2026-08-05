// lib/services/parking_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_endpoints.dart';
import '../models/parking_spot_model.dart';

class ParkingService {
  final http.Client _client;

  ParkingService({http.Client? client}) : _client = client ?? http.Client();

  Future<List<ParkingSpotModel>> getParkingSpots(String token) async {
    final response = await _client.get(
      Uri.parse(ApiEndpoints.parkingSpots),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final List<dynamic> data = responseData['data'] as List<dynamic>;
      return data.map((json) => ParkingSpotModel.fromJson(json as Map<String, dynamic>)).toList();
    } else {
      final Map<String, dynamic> errorData = jsonDecode(response.body);
      throw Exception(errorData['message'] ?? 'Failed to load parking spots');
    }
  }

  Future<Map<String, dynamic>> getParkingSpotQr(String token, String spotId) async {
    final response = await _client.get(
      Uri.parse(ApiEndpoints.parkingSpotQr(spotId)),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      return responseData;
    } else {
      final Map<String, dynamic> errorData = jsonDecode(response.body);
      throw Exception(errorData['message'] ?? 'Failed to load parking spot QR');
    }
  }
}
