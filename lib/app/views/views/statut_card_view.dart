import 'package:flutter/material.dart';

enum StatusType { securite, maintenance, alerte, info, succes, erreur }

enum StatusState { actif, inactif, protege, critique, maintenance, normal }

class StatusCard extends StatelessWidget {
  final String titre;
  final String sousTitre;
  final StatusType type;
  final StatusState etat;
  final Color? couleurPersonnalisee;
  final IconData? iconePersonnalisee;
  final VoidCallback? onTap;
  final bool afficherBadge;
  final String? texteBadge;

  const StatusCard({
    Key? key,
    required this.titre,
    required this.sousTitre,
    this.type = StatusType.info,
    this.etat = StatusState.normal,
    this.couleurPersonnalisee,
    this.iconePersonnalisee,
    this.onTap,
    this.afficherBadge = true,
    this.texteBadge,
  }) : super(key: key);

  Color _getCouleurPrincipale() {
    if (couleurPersonnalisee != null) return couleurPersonnalisee!;

    switch (type) {
      case StatusType.securite:
        switch (etat) {
          case StatusState.protege:
            return Colors.green;
          case StatusState.critique:
            return Colors.red;
          default:
            return Colors.teal;
        }
      case StatusType.maintenance:
        return Colors.orange;
      case StatusType.alerte:
        return Colors.red;
      case StatusType.succes:
        return Colors.green;
      case StatusType.erreur:
        return Colors.red;
      case StatusType.info:
        return Colors.blue;
    }
  }

  IconData _getIcone() {
    if (iconePersonnalisee != null) return iconePersonnalisee!;

    switch (type) {
      case StatusType.securite:
        return Icons.security;
      case StatusType.maintenance:
        return Icons.build;
      case StatusType.alerte:
        return Icons.warning;
      case StatusType.succes:
        return Icons.check_circle;
      case StatusType.erreur:
        return Icons.error;
      case StatusType.info:
        return Icons.info;
    }
  }

  String _getTexteBadge() {
    if (texteBadge != null) return texteBadge!;

    switch (etat) {
      case StatusState.protege:
        return 'PROTÉGÉ';
      case StatusState.actif:
        return 'ACTIF';
      case StatusState.inactif:
        return 'INACTIF';
      case StatusState.critique:
        return 'CRITIQUE';
      case StatusState.maintenance:
        return 'MAINTENANCE';
      case StatusState.normal:
        return 'NORMAL';
    }
  }

  Color _getCouleurBadge() {
    switch (etat) {
      case StatusState.protege:
      case StatusState.actif:
      case StatusState.normal:
        return Colors.green;
      case StatusState.critique:
        return Colors.red;
      case StatusState.maintenance:
        return Colors.orange;
      case StatusState.inactif:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final couleurPrincipale = _getCouleurPrincipale();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border(left: BorderSide(color: couleurPrincipale, width: 4)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Icône
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: couleurPrincipale.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(_getIcone(), color: couleurPrincipale, size: 24),
              ),
              const SizedBox(width: 16),
              // Contenu texte
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      titre,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      sousTitre,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              // Badge de statut
              if (afficherBadge)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _getCouleurBadge(),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check_circle, color: Colors.white, size: 12),
                      const SizedBox(width: 4),
                      Text(
                        _getTexteBadge(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
