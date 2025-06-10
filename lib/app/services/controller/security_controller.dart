// features/client/security/controllers/security_controller.dart
import 'package:get/get.dart';

class SecurityController extends GetxController {
  final sensorData = <String, dynamic>{}.obs;
  final alerts = <SecurityAlert>[].obs;

  void updateSensorData(Map<String, dynamic> data) {
    sensorData.value = data;

    // Ajouter une alerte si nécessaire
    if (data['status'] == 'critical') {
      alerts.insert(
        0,
        SecurityAlert(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          message: data['message'],
          type: AlertType.critical,
          timestamp: DateTime.now(),
        ),
      );
    }

    print('🔒 Données capteur mises à jour: $data');
  }
}

class SecurityAlert {
  final String id;
  final String message;
  final AlertType type;
  final DateTime timestamp;

  SecurityAlert({
    required this.id,
    required this.message,
    required this.type,
    required this.timestamp,
  });
}

enum AlertType { info, warning, critical }
