// lib/models/login_response.dart
import 'user_model.dart';

class LoginResponse {
  final String message;
  final String tokenType;
  final String accessToken;
  final UserModel userData;

  LoginResponse({
    required this.message,
    required this.tokenType,
    required this.accessToken,
    required this.userData,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      message: json['message'] as String,
      tokenType: json['token_type'] as String,
      accessToken: json['access_token'] as String,
      userData: UserModel.fromJson(json['data'] as Map<String, dynamic>),
    );
  }
}
