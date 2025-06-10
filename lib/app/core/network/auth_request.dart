import 'package:gaz_connect/app/core/network/role.dart';

class AuthRequest {
  final String login;
  final String password;
  final Role? role;

  AuthRequest(this.login, this.password, {this.role});

  Map<String, dynamic> toJson() {
    return {"login": login, "password": password, "role": role?.value};
  }
}
