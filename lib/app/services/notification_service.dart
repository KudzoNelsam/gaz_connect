// // shared/services/notification_service.dart
// import 'dart:io';

// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:gaz_connect/app/core/network/api_service.dart';
// import 'package:gaz_connect/app/data/models/auth_data.dart';
// import 'package:get/get.dart';

// class NotificationService extends GetxService {
//   FirebaseMessaging? _messaging;
//   String? _fcmToken;
//   final _notifications = <NotificationModel>[].obs;

//   List<NotificationModel> get notifications => _notifications;

//   Future<void> initialize(AuthUser user) async {
//     try {
//       _messaging = FirebaseMessaging.instance;

//       // ✅ Demander permissions
//       NotificationSettings settings = await _messaging!.requestPermission(
//         alert: true,
//         badge: true,
//         sound: true,
//         provisional: false,
//       );

//       if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//         // ✅ Obtenir le token FCM
//         _fcmToken = await _messaging!.getToken();
//         print('✅ FCM Token: $_fcmToken');

//         // ✅ Envoyer le token au serveur
//         await _sendTokenToServer(user, _fcmToken!);

//         // ✅ Écouter les messages
//         _setupMessageHandlers(user);

//         print('✅ FCM initialisé pour ${user.nomComplet}');
//       }
//     } catch (e) {
//       print('❌ Erreur FCM: $e');
//     }
//   }

//   Future<void> _sendTokenToServer(AuthUser user, String token) async {
//     try {
//       final api = Get.find<ApiService>();
//       await api.post('users/${user.id}/fcm-token', {
//         'fcm_token': token,
//         'platform': Platform.isIOS ? 'ios' : 'android',
//       });
//     } catch (e) {
//       print('❌ Erreur envoi token FCM: $e');
//     }
//   }

//   void _setupMessageHandlers(AuthUser user) {
//     // ✅ Message reçu quand l'app est au premier plan
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       print('📱 Message reçu (foreground): ${message.notification?.title}');
//       _handleMessage(message, user);
//     });

//     // ✅ Message cliqué quand l'app est en arrière-plan
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       print('📱 Message cliqué (background): ${message.notification?.title}');
//       _handleMessageTap(message, user);
//     });

//     // ✅ Message reçu quand l'app était fermée
//     FirebaseMessaging.instance.getInitialMessage().then((
//       RemoteMessage? message,
//     ) {
//       if (message != null) {
//         print('📱 Message au démarrage: ${message.notification?.title}');
//         _handleMessageTap(message, user);
//       }
//     });
//   }

//   void _handleMessage(RemoteMessage message, AuthUser user) {
//     // ✅ Ajouter à la liste des notifications
//     final notification = NotificationModel.fromFCM(message, DateTime.now());
//     _notifications.insert(0, notification);

//     // ✅ Afficher snackbar selon le rôle
//     if (user.role == UserRole.technicien) {
//       _showTechnicianNotification(notification);
//     } else {
//       _showClientNotification(notification);
//     }
//   }

//   void _showTechnicianNotification(NotificationModel notification) {
//     Get.snackbar(
//       notification.title,
//       notification.body,
//       backgroundColor: Colors.blue[50],
//       colorText: Colors.blue[800],
//       icon: Icon(Icons.engineering, color: Colors.blue),
//       duration: const Duration(seconds: 4),
//       onTap: (_) => _handleNotificationTap(notification),
//     );
//   }

//   void _showClientNotification(NotificationModel notification) {
//     Get.snackbar(
//       notification.title,
//       notification.body,
//       backgroundColor: Colors.green[50],
//       colorText: Colors.green[800],
//       icon: Icon(Icons.notifications, color: Colors.green),
//       duration: const Duration(seconds: 4),
//       onTap: (_) => _handleNotificationTap(notification),
//     );
//   }

//   void _handleMessageTap(RemoteMessage message, AuthUser user) {
//     final notification = NotificationModel.fromFCM(message, DateTime.now());
//     _handleNotificationTap(notification);
//   }

//   void _handleNotificationTap(NotificationModel notification) {
//     // ✅ Navigation selon le type de notification
//     switch (notification.type) {
//       case 'new_intervention':
//         Get.toNamed('/technician/interventions');
//         break;
//       case 'delivery_update':
//         Get.toNamed('/client/deliveries');
//         break;
//       case 'sensor_alert':
//         Get.toNamed('/client/security');
//         break;
//       case 'maintenance_reminder':
//         Get.toNamed('/client/maintenance');
//         break;
//       default:
//         print('Type de notification non géré: ${notification.type}');
//     }
//   }

//   void dispose() {
//     _fcmToken = null;
//     _notifications.clear();
//   }
// }

// // Modèle de notification
// class NotificationModel {
//   final String id;
//   final String title;
//   final String body;
//   final String type;
//   final DateTime timestamp;
//   final Map<String, dynamic>? data;

//   NotificationModel({
//     required this.id,
//     required this.title,
//     required this.body,
//     required this.type,
//     required this.timestamp,
//     this.data,
//   });

//   factory NotificationModel.fromFCM(RemoteMessage message, DateTime timestamp) {
//     return NotificationModel(
//       id: message.messageId ?? DateTime.now().millisecondsSinceEpoch.toString(),
//       title: message.notification?.title ?? 'Notification',
//       body: message.notification?.body ?? '',
//       type: message.data['type'] ?? 'general',
//       timestamp: timestamp,
//       data: message.data,
//     );
//   }
// }
