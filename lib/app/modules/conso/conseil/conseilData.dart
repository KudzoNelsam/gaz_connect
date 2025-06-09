import 'package:flutter/material.dart';

class ConseilData {
  final String id;
  final String titre;
  final String description;
  final double economieEstimee;
  final String unite;
  final String periode;
  final ConseilType type;
  final ConseilPriorite priorite;
  final bool estComplete;
  final DateTime dateCreation;
  final IconData? icone;

  ConseilData({
    required this.id,
    required this.titre,
    required this.description,
    required this.economieEstimee,
    this.unite = 'FCFA',
    this.periode = 'mois',
    required this.type,
    this.priorite = ConseilPriorite.moyenne,
    this.estComplete = false,
    required this.dateCreation,
    this.icone,
  });

  String get economieFormatee =>
      '${economieEstimee.toStringAsFixed(0)} $unite/$periode';
  Color get couleurPriorite => priorite.color;
  IconData get iconeConseil => icone ?? type.defaultIcon;
}

enum ConseilType { cuisine, chauffage, entretien, utilisation, securite }

enum ConseilPriorite { haute, moyenne, basse }

extension ConseilTypeExtension on ConseilType {
  IconData get defaultIcon {
    switch (this) {
      case ConseilType.cuisine:
        return Icons.restaurant;
      case ConseilType.chauffage:
        return Icons.whatshot;
      case ConseilType.entretien:
        return Icons.build;
      case ConseilType.utilisation:
        return Icons.settings;
      case ConseilType.securite:
        return Icons.security;
    }
  }

  Color get color {
    switch (this) {
      case ConseilType.cuisine:
        return Colors.orange;
      case ConseilType.chauffage:
        return Colors.red;
      case ConseilType.entretien:
        return Colors.blue;
      case ConseilType.utilisation:
        return Colors.green;
      case ConseilType.securite:
        return Colors.purple;
    }
  }
}

extension ConseilPrioriteExtension on ConseilPriorite {
  Color get color {
    switch (this) {
      case ConseilPriorite.haute:
        return Colors.red;
      case ConseilPriorite.moyenne:
        return Colors.orange;
      case ConseilPriorite.basse:
        return Colors.green;
    }
  }

  String get label {
    switch (this) {
      case ConseilPriorite.haute:
        return 'Priorité haute';
      case ConseilPriorite.moyenne:
        return 'Priorité moyenne';
      case ConseilPriorite.basse:
        return 'Priorité basse';
    }
  }
}
