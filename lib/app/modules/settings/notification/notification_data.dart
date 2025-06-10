import 'package:flutter/material.dart';

class NotificationSettingsData {
  final bool notificationsPushActivees;
  final bool alertesSMSActivees;
  final double seuilAlerte;
  final DateTime derniereModification;
  final String modifiePar;
  final List<TypeNotification> typesActifs;

  NotificationSettingsData({
    required this.notificationsPushActivees,
    required this.alertesSMSActivees,
    required this.seuilAlerte,
    required this.derniereModification,
    required this.modifiePar,
    this.typesActifs = const [],
  });

  String get seuilAlerteFormate => '${seuilAlerte.toStringAsFixed(0)}%';

  // ✅ Copie avec modifications
  NotificationSettingsData copyWith({
    bool? notificationsPushActivees,
    bool? alertesSMSActivees,
    double? seuilAlerte,
    DateTime? derniereModification,
    String? modifiePar,
    List<TypeNotification>? typesActifs,
  }) {
    return NotificationSettingsData(
      notificationsPushActivees:
          notificationsPushActivees ?? this.notificationsPushActivees,
      alertesSMSActivees: alertesSMSActivees ?? this.alertesSMSActivees,
      seuilAlerte: seuilAlerte ?? this.seuilAlerte,
      derniereModification: derniereModification ?? this.derniereModification,
      modifiePar: modifiePar ?? this.modifiePar,
      typesActifs: typesActifs ?? this.typesActifs,
    );
  }
}

enum TypeNotification {
  seuilAtteint,
  commandeAutomatique,
  livraison,
  maintenance,
  urgence,
}

extension TypeNotificationExtension on TypeNotification {
  String get label {
    switch (this) {
      case TypeNotification.seuilAtteint:
        return 'Seuil atteint';
      case TypeNotification.commandeAutomatique:
        return 'Commande automatique';
      case TypeNotification.livraison:
        return 'Livraison';
      case TypeNotification.maintenance:
        return 'Maintenance';
      case TypeNotification.urgence:
        return 'Urgence';
    }
  }

  String get description {
    switch (this) {
      case TypeNotification.seuilAtteint:
        return 'Quand le niveau de gaz atteint le seuil défini';
      case TypeNotification.commandeAutomatique:
        return 'Lors du déclenchement d\'une commande automatique';
      case TypeNotification.livraison:
        return 'Mises à jour sur les livraisons';
      case TypeNotification.maintenance:
        return 'Rappels de maintenance';
      case TypeNotification.urgence:
        return 'Alertes de sécurité urgentes';
    }
  }

  IconData get icon {
    switch (this) {
      case TypeNotification.seuilAtteint:
        return Icons.warning;
      case TypeNotification.commandeAutomatique:
        return Icons.shopping_cart;
      case TypeNotification.livraison:
        return Icons.local_shipping;
      case TypeNotification.maintenance:
        return Icons.build;
      case TypeNotification.urgence:
        return Icons.emergency;
    }
  }
}
