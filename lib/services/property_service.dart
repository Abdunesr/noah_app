// lib/services/property_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_endpoints.dart';
import '../models/property_model.dart';

class PropertyService {
  final http.Client _client;

  PropertyService({http.Client? client}) : _client = client ?? http.Client();

  // Get list of properties
  Future<List<PropertyModel>> getProperties(String token) async {
    final response = await _client.get(
      Uri.parse(ApiEndpoints.properties),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      
      // Check if the response has a 'data' key that contains a list
      if (responseData['data'] is List) {
        final List<dynamic> dataList = responseData['data'] as List<dynamic>;
        return dataList
            .map((item) => PropertyModel.fromJson(item as Map<String, dynamic>))
            .toList();
      } else if (responseData['data'] is Map<String, dynamic>) {
        // If it's a single object, wrap it in a list
        return [PropertyModel.fromJson(responseData['data'] as Map<String, dynamic>)];
      } else {
        throw Exception('Unexpected response format');
      }
    } else {
      final Map<String, dynamic> errorData = jsonDecode(response.body);
      throw Exception(errorData['message'] ?? 'Failed to load property details');
    }
  }

  // Keep the old method for backward compatibility
  Future<PropertyModel> getProperty(String token) async {
    final properties = await getProperties(token);
    if (properties.isEmpty) {
      throw Exception('No properties found');
    }
    return properties.first;
  }

  void dispose() {
    _client.close();
  }
}