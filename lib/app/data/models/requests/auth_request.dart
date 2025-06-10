// app/data/models/requests/auth_request.dart
class LoginRequest {
  final String email;
  final String password;
  final String? deviceId;
  final String? platform;

  LoginRequest({
    required this.email,
    required this.password,
    this.deviceId,
    this.platform,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'device_id': deviceId,
      'platform': platform ?? 'mobile',
      'timestamp': DateTime.now().toIso8601String(),
    };
  }
}
