import 'dart:convert';

import 'package:gaz_connect/app/core/login/rest_response.dart';
import 'package:gaz_connect/app/core/network/api_constant.dart';
import 'package:gaz_connect/app/core/network/auth_service.dart';
import 'package:gaz_connect/app/core/network/impl/auth_service_auth_impl.dart';
import 'package:gaz_connect/app/core/network/tech_service.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../modules/technicien/models/client_details_dto_page.dart';
import '../../../modules/technicien/models/installation_response.dart';

class TechServiceImpl implements TechService {
  final String baseUrl = "${ApiConstants.baseUrlProd}/mobile";
  final AuthService authService = Get.find<AuthServiceImpl>();

  TechServiceImpl();

  @override
  Future<RestResponse> getInstallations() async {
    final response = await http.get(
      Uri.parse('$baseUrl/techniciens/${authService.getUser()!.id}/installations/today'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${authService.getToken()}',
      },
    );
    final r = RestResponse.fromJson(jsonDecode(response.body));
    return r;
  }

  @override
  Future<List<InstallationResponse>> getInstallationsToday() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/techniciens/${authService.getUser()!.id}/installations/today'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${authService.getToken()}',
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final restResponse = RestResponse.fromJson(jsonDecode(response.body));

        print('RestResponse type: ${restResponse.type}');
        print('RestResponse status: ${restResponse.status}');
        print('RestResponse results type: ${restResponse.results.runtimeType}');

        // Vérifier si la requête a réussi (status 200 ou type success)
        if (restResponse.status == 200 && restResponse.results != null) {
          // Si restResponse.results est directement une liste
          if (restResponse.results is List) {
            print('Results is a List with ${(restResponse.results as List).length} items');
            return (restResponse.results as List)
                .map((json) => InstallationResponse.fromJson(json as Map<String, dynamic>))
                .toList();
          }
          // Si restResponse.results est un Map contenant une liste
          else if (restResponse.results is Map) {
            final resultMap = restResponse.results as Map<String, dynamic>;
            print('Results is a Map with keys: ${resultMap.keys.toList()}');

            // Vérifier différentes clés possibles
            List<dynamic>? dataList;
            if (resultMap.containsKey('installations')) {
              dataList = resultMap['installations'] as List?;
            } else if (resultMap.containsKey('data')) {
              dataList = resultMap['data'] as List?;
            } else if (resultMap.containsKey('items')) {
              dataList = resultMap['items'] as List?;
            } else if (resultMap.containsKey('content')) {
              dataList = resultMap['content'] as List?;
            }

            if (dataList != null) {
              print('Found data list with ${dataList.length} items');
              return dataList
                  .map((json) => InstallationResponse.fromJson(json as Map<String, dynamic>))
                  .toList();
            }
          }
        } else {
          print('RestResponse status not 200 or results is null');
          print('Status: ${restResponse.status}, Type: ${restResponse.type}');
        }
      } else {
        print('HTTP Error: ${response.statusCode}');
        throw Exception('Erreur HTTP: ${response.statusCode}');
      }

      return [];
    } catch (e) {
      print('Erreur lors de la récupération des installations: $e');
      throw Exception('Erreur lors de la récupération des installations: $e');
    }
  }

  // impl/tech_service_impl.dart (ajout de la méthode)
  @override
  Future<ClientDetailsDtoPage> getClientDetails(int clientId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/clients/$clientId/technicien'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${authService.getToken()}',
        },
      );

      print('Client details response status: ${response.statusCode}');
      print('Client details response body: ${response.body}');

      if (response.statusCode == 200) {
        final restResponse = RestResponse.fromJson(jsonDecode(response.body));

        if (restResponse.status == 200 && restResponse.results != null) {
          return ClientDetailsDtoPage.fromJson(restResponse.results as Map<String, dynamic>);
        }
      }

      throw Exception('Erreur lors de la récupération des détails client');
    } catch (e) {
      print('Erreur getClientDetails: $e');
      throw Exception('Erreur lors de la récupération des détails client: $e');
    }
  }

  // impl/tech_service_impl.dart (ajout des méthodes)
  @override
  Future<bool> ajouterBouteille(int clientId, BouteilleRequest request) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/clients/$clientId/bouteille'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${authService.getToken()}',
        },
        body: jsonEncode(request.toJson()),
      );

      print('Ajouter bouteille response status: ${response.statusCode}');
      print('Ajouter bouteille response body: ${response.body}');

      if (response.statusCode == 200) {
        final restResponse = RestResponse.fromJson(jsonDecode(response.body));
        return restResponse.status == 200;
      }

      return false;
    } catch (e) {
      print('Erreur ajouterBouteille: $e');
      return false;
    }
  }

  @override
  Future<bool> terminerInstallation(int installationId) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/installations/$installationId/terminer'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Authorization': 'Bearer ${authService.getToken()}',
        },
      );

      print('Terminer installation response status: ${response.statusCode}');
      print('Terminer installation response body: ${response.body}');

      return response.statusCode == 200;
    } catch (e) {
      print('Erreur terminerInstallation: $e');
      return false;
    }
  }
}