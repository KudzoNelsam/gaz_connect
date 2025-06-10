class AuthResponse {
  String token;

  AuthResponse({required this.token});

  factory AuthResponse.toEntity(Map<String, dynamic> data) {
    return AuthResponse(token: data["token"]);
  }
}
