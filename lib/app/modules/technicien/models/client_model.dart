// features/technician/models/client_model.dart
import 'dart:ui';

class ClientModel {
  final String id;
  final String name;
  final String address;
  final int capteurs;
  final int bouteilles;
  final ClientStatus status;
  final String? phone;
  final String? email;

  ClientModel({
    required this.id,
    required this.name,
    required this.address,
    required this.capteurs,
    required this.bouteilles,
    required this.status,
    this.phone,
    this.email,
  });

  factory ClientModel.fromJson(Map<String, dynamic> json) {
    return ClientModel(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      capteurs: json['capteurs'] ?? 0,
      bouteilles: json['bouteilles'] ?? 0,
      status: ClientStatus.fromString(json['status'] ?? 'actif'),
      phone: json['phone'],
      email: json['email'],
    );
  }
}

enum ClientStatus {
  actif('Actif', Color(0xFF4CAF50)),
  aInstaller('À installer', Color(0xFF2196F3)),
  aVerifier('À vérifier', Color(0xFFFF9800));

  const ClientStatus(this.label, this.color);
  final String label;
  final Color color;

  static ClientStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'actif':
        return ClientStatus.actif;
      case 'a_installer':
        return ClientStatus.aInstaller;
      case 'a_verifier':
        return ClientStatus.aVerifier;
      default:
        return ClientStatus.actif;
    }
  }
}
