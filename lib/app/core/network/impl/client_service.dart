// services/client_service.dart
import 'dart:convert';
import 'package:gaz_connect/app/core/network/api_constant.dart';
import 'package:gaz_connect/app/core/network/auth_service.dart';
import 'package:gaz_connect/app/core/network/impl/auth_service_auth_impl.dart';
import 'package:gaz_connect/app/core/login/rest_response.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../modules/client/home/models/home_data.dart';

abstract class ClientService {
  Future<HomeDtoPage> getHomeData();
  Future<bool> couperGaz(int bouteilleId);
}

class ClientServiceImpl implements ClientService {
  final String baseUrl = "${ApiConstants.baseUrlProd}/mobile";
  final AuthService authService = Get.find<AuthServiceImpl>();

  @override
  Future<HomeDtoPage> getHomeData() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/clients/${authService.getUser()!.id}'), // Endpoint à adapter selon votre API
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${authService.getToken()}',
        },
      );

      print('Home data response status: ${response.statusCode}');
      print('Home data response body: ${response.body}');

      if (response.statusCode == 200) {
        final restResponse = RestResponse.fromJson(jsonDecode(response.body));

        if (restResponse.status == 200 && restResponse.results != null) {
          return HomeDtoPage.fromJson(restResponse.results as Map<String, dynamic>);
        }
      }

      throw Exception('Erreur lors de la récupération des données');
    } catch (e) {
      print('Erreur getHomeData: $e');
      // En cas d'erreur, retourner les données mock
      return HomeDtoPage.mockData();
    }
  }

  @override
  Future<bool> couperGaz(int bouteilleId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/bouteilles/$bouteilleId/couper-gaz'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${authService.getToken()}',
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Erreur couperGaz: $e');
      return false;
    }
  }
}