// models/home_dto_page.dart
import 'package:flutter/material.dart';

class HomeDtoPage {
  final List<BouteilleResponseDto> bouteilles;
  final BouteilleResponseDto? bouteille; // Bouteille sélectionnée
  final double consoMoyenne;
  final String predictionDate;

  HomeDtoPage({
    required this.bouteilles,
    this.bouteille,
    required this.consoMoyenne,
    required this.predictionDate,
  });

  factory HomeDtoPage.fromJson(Map<String, dynamic> json) {
    return HomeDtoPage(
      bouteilles: (json['bouteilles'] as List?)
          ?.map((item) => BouteilleResponseDto.fromJson(item))
          .toList() ?? [],
      bouteille: json['bouteille'] != null
          ? BouteilleResponseDto.fromJson(json['bouteille'])
          : null,
      consoMoyenne: (json['consoMoyenne'] ?? 0.0).toDouble(),
      predictionDate: json['pedictionDate'] ?? '', // Note: "pediction" dans le backend
    );
  }

  static HomeDtoPage mockData() {
    return HomeDtoPage(
      bouteilles: [
        BouteilleResponseDto(
          id: 1,
          nom: 'Cuisine',
          poids: 13.0,
          capteurId: 'CAPT_001',
          pourcentageRestant: 15,
        ),
        BouteilleResponseDto(
          id: 2,
          nom: 'Restaurant',
          poids: 13.0,
          capteurId: 'CAPT_002',
          pourcentageRestant: 78,
        ),
        BouteilleResponseDto(
          id: 3,
          nom: 'Bar',
          poids: 6.0,
          capteurId: 'CAPT_003',
          pourcentageRestant: 18,
        ),
        BouteilleResponseDto(
          id: 4,
          nom: 'Terrasse',
          poids: 13.0,
          capteurId: 'CAPT_004',
          pourcentageRestant: 45,
        ),
      ],
      bouteille: BouteilleResponseDto(
        id: 1,
        nom: 'Cuisine',
        poids: 13.0,
        capteurId: 'CAPT_001',
        pourcentageRestant: 15,
      ),
      consoMoyenne: 2.1,
      predictionDate: 'lundi 16 juin vers 14:30',
    );
  }
}

// Réutiliser BouteilleResponseDto existant ou créer une version étendue
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

  // Getters pour l'interface
  Color get statusColor {
    if (pourcentageRestant >= 50) return const Color(0xFF10B981);
    if (pourcentageRestant >= 25) return const Color(0xFFF59E0B);
    return const Color(0xFFFF5722);
  }

  bool get isCritical => pourcentageRestant <= 20;
  bool get isOptimal => capteurId != null;
}