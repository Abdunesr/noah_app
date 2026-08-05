// lib/services/auth_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_endpoints.dart';
import '../models/login_response.dart';
import '../models/user_model.dart';

class AuthService {
  final http.Client _client;

  AuthService({http.Client? client}) : _client = client ?? http.Client();

  // Login Integration with better error handling
  Future<LoginResponse> login(String email, String password) async {
    try {
      final response = await _client
          .post(
            Uri.parse(ApiEndpoints.login),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode({'email': email, 'password': password}),
          )
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () {
              throw Exception('Connection timeout');
            },
          );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return LoginResponse.fromJson(responseData);
      } else {
        // Try to parse error message from response
        try {
          final Map<String, dynamic> errorData = jsonDecode(response.body);
          final errorMessage = errorData['message'] ?? 'Invalid credentials';
          throw Exception(errorMessage);
        } catch (e) {
          // If response body is not JSON or doesn't have message
          throw Exception('Invalid credentials');
        }
      }
    } on http.ClientException catch (e) {
      // Network error - no internet or server unreachable
      print('Network error: $e');
      throw Exception('Invalid credentials');
    } on FormatException catch (e) {
      // Invalid JSON response
      print('Invalid response format: $e');
      throw Exception('Invalid credentials');
    } catch (e) {
      // Any other error
      print('Login error: $e');
      throw Exception('Invalid credentials');
    }
  }

  // Forgot Password placeholder (Ready for future integration)
  Future<Map<String, dynamic>> forgotPassword(String email) async {
    // TODO: Integrate once API response model is provided
    throw UnimplementedError(
      'Forgot Password API integration pending response model',
    );
  }

  // Reset Password placeholder (Ready for future integration)
  Future<Map<String, dynamic>> resetPassword(
    String email,
    String token,
    String password,
  ) async {
    // TODO: Integrate once API response model is provided
    throw UnimplementedError(
      'Reset Password API integration pending response model',
    );
  }

  Future<void> changePassword(
    String token,
    String currentPassword,
    String newPassword,
  ) async {
    try {
      final response = await _client
          .post(
            Uri.parse(ApiEndpoints.changePassword),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode({
              'current_password': currentPassword,
              'new_password': newPassword,
              'new_password_confirmation': newPassword,
            }),
          )
          .timeout(
            const Duration(seconds: 15),
            onTimeout: () {
              throw Exception('Connection timeout');
            },
          );

      if (response.statusCode != 200 && response.statusCode != 201) {
        try {
          final Map<String, dynamic> errorData = jsonDecode(response.body);
          final errorMessage = errorData['message'] ?? 'Failed to update password';
          throw Exception(errorMessage);
        } catch (e) {
          throw Exception('Failed to update password');
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  // Logout Integration (Complete)
  Future<void> logout(String token) async {
    try {
      final response = await _client.post(
        Uri.parse(ApiEndpoints.logout),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        // Silent fail - we don't care if logout fails on server
        print('Logout API failed: ${response.statusCode}');
      }
    } catch (e) {
      // Silent fail for network errors during logout
      print('Logout error: $e');
    }
  }

  // Get current user info (Complete)
  Future<UserModel> getMe(String token) async {
    try {
      final response = await _client
          .get(
            Uri.parse(ApiEndpoints.me),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(
            const Duration(seconds: 15),
            onTimeout: () {
              throw Exception('Connection timeout');
            },
          );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return UserModel.fromJson(responseData['data'] as Map<String, dynamic>);
      } else {
        throw Exception('Invalid credentials');
      }
    } catch (e) {
      // If any error occurs during getMe, throw generic error
      throw Exception('Invalid credentials');
    }
  }
}
