import 'package:flutter/material.dart';

class CapteurData {
  final String id;
  final String nom;
  final String description;
  final String zone;
  final double niveauBatterie;
  final CapteurStatut statut;
  final DateTime derniereActivite;
  final DateTime dateDerniereMessage;
  final bool estConnecte;
  final TypeCapteur type;

  CapteurData({
    required this.id,
    required this.nom,
    required this.description,
    required this.zone,
    required this.niveauBatterie,
    required this.statut,
    required this.derniereActivite,
    required this.dateDerniereMessage,
    this.estConnecte = true,
    this.type = TypeCapteur.gaz,
  });

  String get batterieFormatee => '${niveauBatterie.toStringAsFixed(0)}%';
  Color get couleurStatut => statut.color;
  String get labelStatut => statut.label;
  bool get batterieOk => niveauBatterie >= 50;
  bool get batterieAttention => niveauBatterie >= 20 && niveauBatterie < 50;
  bool get batterieCritique => niveauBatterie < 20;
}

enum CapteurStatut { actif, attention, critique, horsLigne }

enum TypeCapteur { gaz, fumee, temperature, humidite }

extension CapteurStatutExtension on CapteurStatut {
  String get label {
    switch (this) {
      case CapteurStatut.actif:
        return 'Actif';
      case CapteurStatut.attention:
        return 'Attention';
      case CapteurStatut.critique:
        return 'Critique';
      case CapteurStatut.horsLigne:
        return 'Hors ligne';
    }
  }

  Color get color {
    switch (this) {
      case CapteurStatut.actif:
        return const Color(0xFF4CAF50); // Vert
      case CapteurStatut.attention:
        return const Color(0xFFFF9800); // Orange
      case CapteurStatut.critique:
        return const Color(0xFFF44336); // Rouge
      case CapteurStatut.horsLigne:
        return const Color(0xFF9E9E9E); // Gris
    }
  }

  Color get backgroundColor {
    switch (this) {
      case CapteurStatut.actif:
        return const Color(0xFFE8F5E8);
      case CapteurStatut.attention:
        return const Color(0xFFFFF3E0);
      case CapteurStatut.critique:
        return const Color(0xFFFFEBEE);
      case CapteurStatut.horsLigne:
        return const Color(0xFFF5F5F5);
    }
  }
}

extension TypeCapteurExtension on TypeCapteur {
  String get label {
    switch (this) {
      case TypeCapteur.gaz:
        return 'Capteur Gaz';
      case TypeCapteur.fumee:
        return 'Détecteur Fumée';
      case TypeCapteur.temperature:
        return 'Capteur Température';
      case TypeCapteur.humidite:
        return 'Capteur Humidité';
    }
  }

  IconData get icon {
    switch (this) {
      case TypeCapteur.gaz:
        return Icons.sensors;
      case TypeCapteur.fumee:
        return Icons.smoke_free;
      case TypeCapteur.temperature:
        return Icons.thermostat;
      case TypeCapteur.humidite:
        return Icons.water_drop;
    }
  }
}
