// models/installation_response.dart
import 'package:flutter/material.dart';

class InstallationResponse {
  final int id;
  final int clientId;
  final String nomComplet;
  final String adresse;
  final String telephone;
  final int nbrCapteur;
  final int nbrBouteilles; // Gardé pour l'affichage
  final String statut;

  InstallationResponse({
    required this.id,
    required this.clientId,
    required this.nomComplet,
    required this.adresse,
    required this.telephone,
    required this.nbrCapteur,
    required this.nbrBouteilles,
    required this.statut,
  });

  factory InstallationResponse.fromJson(Map<String, dynamic> json) {
    return InstallationResponse(
      id: json['id'] ?? 0,
      clientId: json['clientId'] ?? 0,
      nomComplet: json['nomComplet'] ?? '',
      adresse: json['adresse'] ?? '',
      telephone: json['telephone'] ?? '',
      nbrCapteur: json['nbrCapteur'] ?? 0,
      nbrBouteilles: json['nbrBouteilles'] ?? 0, // Peut être calculé côté front
      statut: json['statut'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'clientId': clientId,
      'nomComplet': nomComplet,
      'adresse': adresse,
      'telephone': telephone,
      'nbrCapteur': nbrCapteur,
      'nbrBouteilles': nbrBouteilles,
      'statut': statut,
    };
  }
}

// Extension pour gérer les styles selon le statut (inchangée)
extension StatutExtension on String {
  Color get statutColor {
    switch (toLowerCase()) {
      case 'terminé':
        return Colors.green[700]!;
      case 'programmé':
        return Colors.blue[700]!;
      default:
        return Colors.grey[700]!;
    }
  }

  Color get statutBackgroundColor {
    switch (toLowerCase()) {
      case 'terminé':
        return Colors.green[100]!;
      case 'programmé':
        return Colors.blue[100]!;
      default:
        return Colors.grey[100]!;
    }
  }

  Color get statutBorderColor {
    switch (toLowerCase()) {
      case 'terminé':
        return Colors.green;
      case 'programmé':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  String get statutLabel {
    switch (toLowerCase()) {
      case 'terminé':
        return 'Terminé';
      case 'programmé':
        return 'Programmé';
      default:
        return this;
    }
  }
}