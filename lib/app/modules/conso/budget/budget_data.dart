import 'package:flutter/material.dart';

class BudgetData {
  final String periode;
  final double budgetPrevu;
  final double moisActuel;
  final double moisDernier;
  final String devise;
  final DateTime dateCalcul;
  final BudgetTendance tendance;

  BudgetData({
    required this.periode,
    required this.budgetPrevu,
    required this.moisActuel,
    required this.moisDernier,
    this.devise = 'FCFA',
    required this.dateCalcul,
    required this.tendance,
  });

  double get economie => budgetPrevu - moisActuel;
  double get variationPourcentage =>
      moisDernier > 0 ? ((moisActuel - moisDernier) / moisDernier) * 100 : 0;
  bool get sousLeBudget => moisActuel <= budgetPrevu;
}

enum BudgetTendance { hausse, baisse, stable }

extension BudgetTendanceExtension on BudgetTendance {
  Color get color {
    switch (this) {
      case BudgetTendance.hausse:
        return Colors.red;
      case BudgetTendance.baisse:
        return Colors.green;
      case BudgetTendance.stable:
        return Colors.blue;
    }
  }

  IconData get icon {
    switch (this) {
      case BudgetTendance.hausse:
        return Icons.trending_up;
      case BudgetTendance.baisse:
        return Icons.trending_down;
      case BudgetTendance.stable:
        return Icons.trending_flat;
    }
  }

  String get symbole {
    switch (this) {
      case BudgetTendance.hausse:
        return '↗';
      case BudgetTendance.baisse:
        return '↘';
      case BudgetTendance.stable:
        return '→';
    }
  }
}
