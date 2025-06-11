// models/client_details_dto_page.dart
import 'package:flutter/material.dart';

class ClientDetailsDtoPage {
  final ClientResponse client;
  final List<BouteilleResponseDto> bouteilles;
  final List<int> typesBouteille; // Nouveau champ

  ClientDetailsDtoPage({
    required this.client,
    required this.bouteilles,
    required this.typesBouteille
  });

  factory ClientDetailsDtoPage.fromJson(Map<String, dynamic> json) {
    return ClientDetailsDtoPage(
      client: ClientResponse.fromJson(json['client'] ?? {}),
      bouteilles: (json['bouteilles'] as List?)
          ?.map((item) => BouteilleResponseDto.fromJson(item))
          .toList() ?? [],
      typesBouteille: (json['typesBouteille'] as List?)
          ?.map((item) => item as int)
          .toList() ?? [],
    );
  }
}

// Nouveau model pour la requête
class BouteilleRequest {
  final double poids;
  final String nom;
  final String capteurId;

  BouteilleRequest({
    required this.poids,
    required this.nom,
    required this.capteurId,
  });

  Map<String, dynamic> toJson() {
    return {
      'poids': poids,
      'nom': nom,
      'capteurId': capteurId,
    };
  }
}

class ClientResponse {
  final int id;
  final String nomComplet;
  final String adresse;
  final String telephone;

  ClientResponse({
    required this.id,
    required this.nomComplet,
    required this.adresse,
    required this.telephone,
  });

  factory ClientResponse.fromJson(Map<String, dynamic> json) {
    return ClientResponse(
      id: json['id'] ?? 0,
      nomComplet: json['nomComplet'] ?? '',
      adresse: json['adresse'] ?? '',
      telephone: json['telephone'] ?? '',
    );
  }
}



class BouteilleResponseDto {
  final int id;
  final String nom;
  final double poids;
  final String? capteurId;
  final int pourcentageRestant;

  BouteilleResponseDto({
    required this.id,
    required this.nom,
    required this.poids,
    this.capteurId,
    required this.pourcentageRestant,
  });

  factory BouteilleResponseDto.fromJson(Map<String, dynamic> json) {
    return BouteilleResponseDto(
      id: json['id'] ?? 0,
      nom: json['nom'] ?? '',
      poids: (json['poids'] ?? 0.0).toDouble(),
      capteurId: json['capteurId'],
      pourcentageRestant: json['pourcentageRestant'] ?? 0,
    );
  }

  String get poidsFormatted => '${poids.toInt()}kg';

  Color get statusColor {
    if (pourcentageRestant >= 50) return const Color(0xFF10B981);
    if (pourcentageRestant >= 25) return const Color(0xFFF59E0B);
    return const Color(0xFFEF4444);
  }

  String get statusLabel {
    if (capteurId == null) return 'Non assignée';
    if (pourcentageRestant >= 50) return 'Actif';
    if (pourcentageRestant >= 25) return 'Niveau bas';
    return 'Critique';
  }

  Color get statusBackgroundColor {
    if (capteurId == null) return const Color(0xFF6B7280).withOpacity(0.1);
    if (pourcentageRestant >= 50) return const Color(0xFF10B981).withOpacity(0.1);
    if (pourcentageRestant >= 25) return const Color(0xFFF59E0B).withOpacity(0.1);
    return const Color(0xFFEF4444).withOpacity(0.1);
  }
}