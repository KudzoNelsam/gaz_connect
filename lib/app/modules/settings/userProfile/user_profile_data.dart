import 'package:flutter/material.dart';

class UserProfileData {
  final String id;
  final String nomComplet;
  final String telephone;
  final String email;
  final String? avatar;
  final String initiales;
  final DateTime dateInscription;
  final DateTime derniereConnexion;
  final bool estActif;
  final UserType typeUtilisateur;

  UserProfileData({
    required this.id,
    required this.nomComplet,
    required this.telephone,
    required this.email,
    this.avatar,
    required this.initiales,
    required this.dateInscription,
    required this.derniereConnexion,
    this.estActif = true,
    this.typeUtilisateur = UserType.client,
  });

  String get telephoneFormate => telephone.replaceAllMapped(
    RegExp(r'(\+221)(\d{2})(\d{3})(\d{2})(\d{2})'),
    (match) => '${match[1]} ${match[2]} ${match[3]} ${match[4]} ${match[5]}',
  );

  Color get couleurAvatar => _getCouleurFromInitiales(initiales);

  static Color _getCouleurFromInitiales(String initiales) {
    // Génère une couleur basée sur les initiales
    int hash = initiales.hashCode;
    List<Color> couleurs = [
      const Color(0xFF1976D2), // Bleu
      const Color(0xFF388E3C), // Vert
      const Color(0xFFF57C00), // Orange
      const Color(0xFF7B1FA2), // Violet
      const Color(0xFFD32F2F), // Rouge
      const Color(0xFF303F9F), // Indigo
      const Color(0xFF455A64), // Bleu gris
    ];
    return couleurs[hash.abs() % couleurs.length];
  }
}

enum UserType { client, admin, technicien }

extension UserTypeExtension on UserType {
  String get label {
    switch (this) {
      case UserType.client:
        return 'Client';
      case UserType.admin:
        return 'Administrateur';
      case UserType.technicien:
        return 'Technicien';
    }
  }

  Color get color {
    switch (this) {
      case UserType.client:
        return Colors.blue;
      case UserType.admin:
        return Colors.red;
      case UserType.technicien:
        return Colors.green;
    }
  }
}
