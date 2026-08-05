// lib/services/maintenance_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/maintenance_model.dart';
import 'api_endpoints.dart';

class MaintenanceService {
  final http.Client client;

  MaintenanceService({http.Client? client}) : client = client ?? http.Client();

  Future<PaginatedResponse<MaintenanceRequest>> getMaintenanceRequests({
    required String token,
    int page = 1,
    int perPage = 20,
  }) async {
    try {
      final response = await client.get(
        Uri.parse(
          '${ApiEndpoints.maintenanceRequests}?page=$page&per_page=$perPage',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        // The API returns data wrapped in a "data" object
        final Map<String, dynamic> responseData =
            jsonResponse['data'] as Map<String, dynamic>;

        return PaginatedResponse<MaintenanceRequest>.fromJson(
          responseData,
          (json) => MaintenanceRequest.fromJson(json),
        );
      } else if (response.statusCode == 401) {
        throw Exception('Session expired. Please login again.');
      } else {
        throw Exception(
          'Failed to load maintenance requests: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching maintenance requests: $e');
    }
  }

  Future<MaintenanceRequest> createMaintenanceRequest({
    required String token,
    required Map<String, dynamic> requestData,
  }) async {
    try {
      final response = await client.post(
        Uri.parse(ApiEndpoints.maintenanceRequests),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(requestData),
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        // Assuming the API returns the created request directly
        return MaintenanceRequest.fromJson(
          jsonResponse['data'] ?? jsonResponse,
        );
      } else if (response.statusCode == 401) {
        throw Exception('Session expired. Please login again.');
      } else {
        final errorBody = json.decode(response.body);
        final errorMessage =
            errorBody['message'] ?? 'Failed to create maintenance request';
        throw Exception(errorMessage);
      }
    } catch (e) {
      throw Exception('Error creating maintenance request: $e');
    }
  }

  Future<MaintenanceRequest> getMaintenanceRequestById({
    required String token,
    required int id,
  }) async {
    try {
      final response = await client.get(
        Uri.parse('${ApiEndpoints.maintenanceRequests}/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return MaintenanceRequest.fromJson(
          jsonResponse['data'] ?? jsonResponse,
        );
      } else if (response.statusCode == 401) {
        throw Exception('Session expired. Please login again.');
      } else if (response.statusCode == 404) {
        throw Exception('Maintenance request not found');
      } else {
        throw Exception(
          'Failed to load maintenance request: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching maintenance request: $e');
    }
  }

  void dispose() {
    client.close();
  }
}
