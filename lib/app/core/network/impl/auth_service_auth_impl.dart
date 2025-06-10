import 'dart:convert';

import 'package:gaz_connect/app/core/login/rest_response.dart';
import 'package:gaz_connect/app/core/network/api_constant.dart';
import 'package:gaz_connect/app/core/network/auth_request.dart';
import 'package:gaz_connect/app/core/network/auth_response.dart';
import 'package:gaz_connect/app/core/network/auth_service.dart';
import 'package:gaz_connect/app/core/network/user_connected.dart';
import 'package:gaz_connect/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;

class AuthServiceImpl implements AuthService {
  final String baseUrl = "${ApiConstants.baseUrlProd}/auth";

  AuthServiceImpl();

  @override
  Future<bool> login(String login, String password) async {
    final url = Uri.parse('$baseUrl/login');

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(AuthRequest(login, password)),
    );

    if (response.statusCode == 200) {
      final data = RestResponse.fromJson(jsonDecode(response.body));
      final token = AuthResponse.toEntity(data.results).token;
      var box = Hive.box(ApiConstants.boxName);
      box.put("token", token);
      return true;
    } else {
      return false;
    }
  }

  @override
  String? getToken() {
    var box = Hive.box(ApiConstants.boxName);
    return box.get("token");
  }

  @override
  UserConnected? getUser() {
    var box = Hive.box(ApiConstants.boxName);
    return box.get("userConnected");
  }

  @override
  Future<void> logout() async {
    var box = Hive.box(ApiConstants.boxName);
    await box.clear();
    Get.offAllNamed(Routes.LOGIN);
  }

  @override
  Future<RestResponse> getUserConnected() async {
    final response = await http.get(
      Uri.parse('$baseUrl/me'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${getToken()}',
      },
    );
    final r = RestResponse.fromJson(jsonDecode(response.body));
    final UserConnected userConnected = UserConnected.toEntity(r.results);
    var box = Hive.box(ApiConstants.boxName);
    box.put("userConnected", userConnected);
    return r;
  }
}
