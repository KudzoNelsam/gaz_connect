import 'package:flutter/material.dart';

class CommandeAutomatiqueData {
  final bool estActive;
  final double seuilPourcentage;
  final String description;
  final DateTime derniereCommande;
  final DateTime prochainVerification;

  CommandeAutomatiqueData({
    required this.estActive,
    required this.seuilPourcentage,
    required this.description,
    required this.derniereCommande,
    required this.prochainVerification,
  });

  String get seuilFormate =>
      'Seuil: ${seuilPourcentage.toStringAsFixed(0)}% restant';
}

class LivraisonData {
  final String id;
  final String fournisseur;
  final String eta;
  final String adresse;
  final double progression;
  final LivraisonStatut statut;
  final DateTime dateCommande;
  final DateTime dateEstimee;
  final String? numeroSuivi;

  LivraisonData({
    required this.id,
    required this.fournisseur,
    required this.eta,
    required this.adresse,
    required this.progression,
    required this.statut,
    required this.dateCommande,
    required this.dateEstimee,
    this.numeroSuivi,
  });

  String get progressionFormatee =>
      '${(progression * 100).toStringAsFixed(0)}%';
  Color get couleurStatut => statut.color;
  String get labelStatut => statut.label;
}

enum LivraisonStatut { preparee, enRoute, proche, livree, retardee }

extension LivraisonStatutExtension on LivraisonStatut {
  String get label {
    switch (this) {
      case LivraisonStatut.preparee:
        return 'Préparée';
      case LivraisonStatut.enRoute:
        return 'En livraison'; // ✅ Comme dans votre image
      case LivraisonStatut.proche:
        return 'Proche';
      case LivraisonStatut.livree:
        return 'Livrée';
      case LivraisonStatut.retardee:
        return 'Retardée';
    }
  }

  // ✅ COULEURS CORRIGÉES pour le badge bleu
  Color get color {
    switch (this) {
      case LivraisonStatut.preparee:
        return const Color(0xFFFF9800); // Orange
      case LivraisonStatut.enRoute:
        return const Color(0xFF1976D2); // ✅ Bleu comme dans l'image
      case LivraisonStatut.proche:
        return const Color(0xFF4CAF50); // Vert
      case LivraisonStatut.livree:
        return const Color(0xFF2E7D32); // Vert foncé
      case LivraisonStatut.retardee:
        return const Color(0xFFF44336); // Rouge
    }
  }

  IconData get icon {
    switch (this) {
      case LivraisonStatut.preparee:
        return Icons.inventory;
      case LivraisonStatut.enRoute:
        return Icons.local_shipping; // ✅ Camion pour "En livraison"
      case LivraisonStatut.proche:
        return Icons.near_me;
      case LivraisonStatut.livree:
        return Icons.check_circle;
      case LivraisonStatut.retardee:
        return Icons.warning;
    }
  }
}
