// core/network/api_constants.dart
class ApiConstants {
  // Base URLs par environnement
  static const String baseUrlDev = 'http://localhost:3000';
  static const String baseUrlProd = 'https://gazconnect-ja01.onrender.com';
  static const String boxName = 'auth_box';

  // Endpoints principaux
  static const String auth = 'users';
  static const String users = 'users';
  static const String consumption = 'consumption';
  static const String security = 'security';
  static const String delivery = 'delivery';
  static const String maintenance = 'maintenance';
  static const String installations = 'installations';

  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);

  // Headers
  static const String contentType = 'application/json';
  static const String accept = 'application/json';
}