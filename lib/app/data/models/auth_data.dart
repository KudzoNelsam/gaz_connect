// app/data/models/auth_data.dart
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

// part 'auth_data.g.dart';

@HiveType(typeId: 0)
class AuthUser {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String login;
  @HiveField(2)
  final String nom;
  @HiveField(3)
  final String prenom;
  @HiveField(4)
  final String email;
  @HiveField(5)
  final String? telephone;
  @HiveField(6)
  final UserRole role; // ✅ UN SEUL RÔLE
  @HiveField(7)
  final UserStatus status;
  @HiveField(8)
  final DateTime dateCreation;

  AuthUser({
    required this.id,
    required this.login,
    required this.nom,
    required this.prenom,
    required this.email,
    this.telephone,
    required this.role,
    this.status = UserStatus.actif,
    required this.dateCreation,
  });

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      id: json['id'] ?? '',
      login: json['login'] ?? '',
      nom: json['nom'] ?? '',
      prenom: json['prenom'] ?? '',
      email: json['email'] ?? '',
      telephone: json['telephone'],
      role: UserRole.values.firstWhere(
        (r) => r.name == json['role'],
        orElse: () => UserRole.client,
      ),
      status: UserStatus.values.firstWhere(
        (s) => s.name == json['status'],
        orElse: () => UserStatus.actif,
      ),
      dateCreation: DateTime.parse(json['date_creation']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'login': login,
      'nom': nom,
      'prenom': prenom,
      'email': email,
      'telephone': telephone,
      'role': role.name, // ✅ UN SEUL RÔLE (string)
      'status': status.name,
      'date_creation': dateCreation.toIso8601String(),
    };
  }

  // ✅ Getters utiles
  String get nomComplet => '$prenom $nom';
  bool get estActif => status == UserStatus.actif;

  // ✅ Permissions basées sur le rôle unique
  List<String> get permissions => role.permissions;

  // ✅ Vérifications de rôle simples
  bool get isClient => role == UserRole.client;
  bool get isTechnicien => role == UserRole.technicien;
  bool get isAdmin => role == UserRole.admin;
}

enum UserRole { client, technicien, admin }

enum UserStatus { actif, inactif, suspendu, archive }

// ✅ Extension pour un rôle unique avec ses permissions
extension UserRoleExtension on UserRole {
  String get label {
    switch (this) {
      case UserRole.client:
        return 'Client';
      case UserRole.technicien:
        return 'Technicien';
      case UserRole.admin:
        return 'Administrateur';
    }
  }

  Color get color {
    switch (this) {
      case UserRole.client:
        return Colors.blue;
      case UserRole.technicien:
        return Colors.green;
      case UserRole.admin:
        return Colors.red;
    }
  }

  IconData get icon {
    switch (this) {
      case UserRole.client:
        return Icons.person;
      case UserRole.technicien:
        return Icons.engineering;
      case UserRole.admin:
        return Icons.admin_panel_settings;
    }
  }

  // ✅ Permissions fixes par rôle
  List<String> get permissions {
    switch (this) {
      case UserRole.client:
        return ['view_consumption', 'view_deliveries', 'manage_profile'];
      case UserRole.technicien:
        return [
          'view_consumption',
          'view_deliveries',
          'manage_profile',
          'manage_sensors',
          'view_diagnostics',
          'manage_maintenance',
        ];
      case UserRole.admin:
        return [
          'view_consumption',
          'view_deliveries',
          'manage_profile',
          'manage_sensors',
          'view_diagnostics',
          'manage_maintenance',
          'manage_users',
          'system_config',
          'view_analytics',
        ];
    }
  }

  // ✅ Vérifier une permission spécifique
  bool hasPermission(String permission) {
    return permissions.contains(permission);
  }
}
