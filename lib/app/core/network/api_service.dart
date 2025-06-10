import 'package:gaz_connect/app/core/login/rest_response.dart';

abstract class ApiService {
  Future<RestResponse> findAll();
  Future<RestResponse> getOne(int id);
  Future<RestResponse> add(dynamic data);
  Future<RestResponse> update(dynamic data);
}
