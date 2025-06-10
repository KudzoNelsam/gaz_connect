// // shared/services/websocket_service.dart
// import 'dart:async';
// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:gaz_connect/app/data/models/auth_data.dart';
// import 'package:gaz_connect/app/modules/technicien/home/controllers/technicien_home_controller.dart';
// import 'package:gaz_connect/app/services/controller/security_controller.dart';
// import 'package:get/get.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';

// class WebSocketService extends GetxService {
//   WebSocketChannel? _channel;
//   StreamSubscription? _subscription;
//   final _isConnected = false.obs;
//   final _reconnectAttempts = 0.obs;
//   Timer? _heartbeatTimer;

//   bool get isConnected => _isConnected.value;

//   Future<void> connect(AuthUser user) async {
//     try {
//       final wsUrl =
//           'ws://localhost:3001/ws?userId=${user.id}&role=${user.role.name}';

//       print('🔌 Connexion WebSocket: $wsUrl');
//       _channel = WebSocketChannel.connect(Uri.parse(wsUrl));

//       // ✅ Écouter les messages
//       _subscription = _channel!.stream.listen(
//         (data) => _handleMessage(data, user),
//         onError: (error) => _handleError(error, user),
//         onDone: () => _handleDisconnection(user),
//       );

//       _isConnected.value = true;
//       _reconnectAttempts.value = 0;

//       // ✅ Heartbeat pour maintenir la connexion
//       _startHeartbeat();

//       print('✅ WebSocket connecté pour ${user.nomComplet}');
//     } catch (e) {
//       print('❌ Erreur connexion WebSocket: $e');
//       _scheduleReconnect(user);
//     }
//   }

//   void _handleMessage(dynamic data, AuthUser user) {
//     try {
//       final message = json.decode(data);
//       print('📡 Message WebSocket reçu: $message');

//       switch (message['type']) {
//         case 'sensor_update':
//           _handleSensorUpdate(message, user);
//           break;
//         case 'delivery_status':
//           _handleDeliveryUpdate(message, user);
//           break;
//         case 'new_intervention':
//           _handleNewIntervention(message, user);
//           break;
//         case 'client_data_update':
//           _handleClientDataUpdate(message, user);
//           break;
//         case 'heartbeat_response':
//           // Connexion maintenue
//           break;
//         default:
//           print('Type de message WebSocket non géré: ${message['type']}');
//       }
//     } catch (e) {
//       print('❌ Erreur traitement message WebSocket: $e');
//     }
//   }

//   void _handleSensorUpdate(Map<String, dynamic> message, AuthUser user) {
//     if (user.isClient) {
//       // ✅ Mettre à jour les données de sécurité en temps réel
//       Get.find<SecurityController>()?.updateSensorData(message['data']);

//       // ✅ Notification si critique
//       if (message['data']['status'] == 'critical') {
//         Get.snackbar(
//           '🚨 Alerte Capteur',
//           message['data']['message'],
//           backgroundColor: Colors.red[50],
//           colorText: Colors.red[800],
//           duration: const Duration(seconds: 6),
//         );
//       }
//     }
//   }

//   void _handleDeliveryUpdate(Map<String, dynamic> message, AuthUser user) {
//     // ✅ Mettre à jour le statut de livraison
//     if (user.isClient) {
//       // Get.find<DeliveryController>()?.updateDeliveryStatus(message['data']);
//     }

//     Get.snackbar(
//       '📦 Livraison',
//       message['data']['message'],
//       backgroundColor: Colors.blue[50],
//       colorText: Colors.blue[800],
//     );
//   }

//   void _handleNewIntervention(Map<String, dynamic> message, AuthUser user) {
//     if (user.isTechnicien) {
//       // ✅ Nouvelle intervention assignée
//       Get.find<TechnicienController>()?.loadClients(); // Refresh

//       Get.snackbar(
//         '🔧 Nouvelle Intervention',
//         message['data']['message'],
//         backgroundColor: Colors.green[50],
//         colorText: Colors.green[800],
//         duration: const Duration(seconds: 5),
//       );
//     }
//   }

//   void _handleClientDataUpdate(Map<String, dynamic> message, AuthUser user) {
//     if (user.isTechnicien) {
//       // ✅ Données client mises à jour par un autre technicien
//       Get.find<TechnicienController>()?.loadClients(); // Refresh
//     }
//   }

//   void _handleError(dynamic error, AuthUser user) {
//     print('❌ Erreur WebSocket: $error');
//     _isConnected.value = false;
//     _scheduleReconnect(user);
//   }

//   void _handleDisconnection(AuthUser user) {
//     print('🔌 WebSocket déconnecté');
//     _isConnected.value = false;
//     _scheduleReconnect(user);
//   }

//   void _scheduleReconnect(AuthUser user) {
//     if (_reconnectAttempts.value < 5) {
//       _reconnectAttempts.value++;
//       final delay = Duration(seconds: _reconnectAttempts.value * 2);

//       print(
//         '🔄 Reconnexion WebSocket dans ${delay.inSeconds}s (tentative ${_reconnectAttempts.value})',
//       );

//       Timer(delay, () => connect(user));
//     } else {
//       print('❌ Trop de tentatives de reconnexion WebSocket');
//     }
//   }

//   void _startHeartbeat() {
//     _heartbeatTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
//       if (_isConnected.value) {
//         sendMessage({
//           'type': 'heartbeat',
//           'timestamp': DateTime.now().toIso8601String(),
//         });
//       }
//     });
//   }

//   void sendMessage(Map<String, dynamic> message) {
//     if (_isConnected.value && _channel != null) {
//       _channel!.sink.add(json.encode(message));
//     }
//   }

//   void disconnect() {
//     _heartbeatTimer?.cancel();
//     _subscription?.cancel();
//     _channel?.sink.close();
//     _isConnected.value = false;
//     _reconnectAttempts.value = 0;
//     print('✅ WebSocket déconnecté proprement');
//   }
// }
