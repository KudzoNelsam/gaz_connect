// models/intervention_dto_page.dart
import 'package:flutter/material.dart';

class InterventionDtoPage {
  final int totalInterventions;
  final int completedInterventions;
  final List<InterventionItem> interventions;

  InterventionDtoPage({
    required this.totalInterventions,
    required this.completedInterventions,
    required this.interventions,
  });

  // Données d'exemple

}

class InterventionItem {
  final String clientName;
  final String address;
  final String date;
  final String time;
  final String duration;
  final String type;
  final Color typeColor;
  final bool isCompleted;

  InterventionItem({
    required this.clientName,
    required this.address,
    required this.date,
    required this.time,
    required this.duration,
    required this.type,
    required this.typeColor,
    required this.isCompleted,
  });
}