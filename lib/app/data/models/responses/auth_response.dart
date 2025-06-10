// app/data/models/responses/auth_response.dart
import '../auth_data.dart';

class LoginResponse {
  final bool success;
  final AuthUser? user;
  final String? accessToken;

  final DateTime? tokenExpiry;
  final String? message;
  final String? errorCode;

  LoginResponse({
    required this.success,
    this.user,
    this.accessToken,
    this.tokenExpiry,
    this.message,
    this.errorCode,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      success: json['success'] ?? false,
      user: json['user'] != null ? AuthUser.fromJson(json['user']) : null,
      accessToken: json['access_token'],
      tokenExpiry: json['token_expiry'] != null
          ? DateTime.parse(json['token_expiry'])
          : null,
      message: json['message'],
      errorCode: json['error_code'],
    );
  }
}

class RefreshTokenResponse {
  final bool success;
  final String? accessToken;
  final DateTime? tokenExpiry;
  final String? message;

  RefreshTokenResponse({
    required this.success,
    this.accessToken,
    this.tokenExpiry,
    this.message,
  });

  factory RefreshTokenResponse.fromJson(Map<String, dynamic> json) {
    return RefreshTokenResponse(
      success: json['success'] ?? false,
      accessToken: json['access_token'],
      tokenExpiry: json['token_expiry'] != null
          ? DateTime.parse(json['token_expiry'])
          : null,
      message: json['message'],
    );
  }
}

class LogoutResponse {
  final bool success;
  final String? message;

  LogoutResponse({required this.success, this.message});

  factory LogoutResponse.fromJson(Map<String, dynamic> json) {
    return LogoutResponse(
      success: json['success'] ?? false,
      message: json['message'],
    );
  }
}
