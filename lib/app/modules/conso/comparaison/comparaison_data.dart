import 'package:flutter/material.dart';

class ComparisonData {
  final double votreConsommation;
  final double moyenneSimilaire;
  final String unite;
  final String periode;
  final DateTime dateCalcul;
  final ComparisonType type;

  ComparisonData({
    required this.votreConsommation,
    required this.moyenneSimilaire,
    this.unite = 'kg/jour',
    this.periode = 'jour',
    required this.dateCalcul,
    required this.type,
  });

  double get difference => votreConsommation - moyenneSimilaire;
  double get pourcentageDifference =>
      moyenneSimilaire > 0 ? (difference / moyenneSimilaire) * 100 : 0;
  bool get estMeilleur => votreConsommation < moyenneSimilaire;

  ComparisonPerformance get performance {
    double pourcentage = pourcentageDifference.abs();
    if (pourcentage <= 10) return ComparisonPerformance.similaire;
    if (estMeilleur) {
      if (pourcentage >= 25) return ComparisonPerformance.excellent;
      if (pourcentage >= 15) return ComparisonPerformance.tresBien;
      return ComparisonPerformance.bien;
    } else {
      if (pourcentage >= 25) return ComparisonPerformance.mauvais;
      if (pourcentage >= 15) return ComparisonPerformance.ameliorable;
      return ComparisonPerformance.moyen;
    }
  }
}

enum ComparisonType { quotidienne, hebdomadaire, mensuelle }

enum ComparisonPerformance {
  excellent,
  tresBien,
  bien,
  similaire,
  moyen,
  ameliorable,
  mauvais,
}

extension ComparisonPerformanceExtension on ComparisonPerformance {
  String get message {
    switch (this) {
      case ComparisonPerformance.excellent:
        return 'Excellent ! Bien en dessous de la moyenne';
      case ComparisonPerformance.tresBien:
        return 'Très bien en dessous de la moyenne';
      case ComparisonPerformance.bien:
        return 'En dessous de la moyenne';
      case ComparisonPerformance.similaire:
        return 'Similaire à la moyenne';
      case ComparisonPerformance.moyen:
        return 'Légèrement au-dessus de la moyenne';
      case ComparisonPerformance.ameliorable:
        return 'Au-dessus de la moyenne';
      case ComparisonPerformance.mauvais:
        return 'Bien au-dessus de la moyenne';
    }
  }

  Color get color {
    switch (this) {
      case ComparisonPerformance.excellent:
      case ComparisonPerformance.tresBien:
        return Colors.green;
      case ComparisonPerformance.bien:
        return Colors.lightGreen;
      case ComparisonPerformance.similaire:
        return Colors.blue;
      case ComparisonPerformance.moyen:
        return Colors.orange;
      case ComparisonPerformance.ameliorable:
      case ComparisonPerformance.mauvais:
        return Colors.red;
    }
  }

  String get messagePersonnalise {
    switch (this) {
      case ComparisonPerformance.excellent:
      case ComparisonPerformance.tresBien:
      case ComparisonPerformance.bien:
        return 'en dessous de la moyenne';
      case ComparisonPerformance.similaire:
        return 'similaire à la moyenne';
      case ComparisonPerformance.moyen:
      case ComparisonPerformance.ameliorable:
      case ComparisonPerformance.mauvais:
        return 'au-dessus de la moyenne';
    }
  }
}
