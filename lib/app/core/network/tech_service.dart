import 'package:gaz_connect/app/core/login/rest_response.dart';
import 'package:gaz_connect/app/core/network/user_connected.dart';

abstract class AuthService {
  Future<bool> login(String login, String password);
  String? getToken();
  Future<void> logout();
  Future<RestResponse> getUserConnected();
  UserConnected? getUser();
}
