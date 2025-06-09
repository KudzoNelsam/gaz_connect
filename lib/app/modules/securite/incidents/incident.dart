import 'package:flutter/material.dart';

class Incident {
  final String id;
  final String titre;
  final DateTime dateHeure;
  final Duration duree;
  final String action;
  final IncidentType type;
  final IncidentStatus status;
  final IconData? icone;

  Incident({
    required this.id,
    required this.titre,
    required this.dateHeure,
    required this.duree,
    required this.action,
    required this.type,
    this.status = IncidentStatus.resolu,
    this.icone,
  });
}

enum IncidentType { fuite, niveauCritique, testCapteur, autre }

enum IncidentStatus { resolu, enCours, attente }

extension IncidentTypeExtension on IncidentType {
  IconData get icon {
    switch (this) {
      case IncidentType.fuite:
        return Icons.warning;
      case IncidentType.niveauCritique:
        return Icons.warning;
      case IncidentType.testCapteur:
        return Icons.warning;
      case IncidentType.autre:
        return Icons.error_outline;
    }
  }

  Color get color {
    switch (this) {
      case IncidentType.fuite:
        return Colors.orange;
      case IncidentType.niveauCritique:
        return Colors.orange;
      case IncidentType.testCapteur:
        return Colors.orange;
      case IncidentType.autre:
        return Colors.red;
    }
  }
}

extension IncidentStatusExtension on IncidentStatus {
  String get label {
    switch (this) {
      case IncidentStatus.resolu:
        return 'Résolu';
      case IncidentStatus.enCours:
        return 'En cours';
      case IncidentStatus.attente:
        return 'En attente';
    }
  }

  Color get color {
    switch (this) {
      case IncidentStatus.resolu:
        return Colors.green;
      case IncidentStatus.enCours:
        return Colors.orange;
      case IncidentStatus.attente:
        return Colors.red;
    }
  }
}
