import 'package:flutter/material.dart';

import 'package:get/get.dart';

enum TypeAlerte { critique, avertissement, info, succes }

class AlertCardView extends GetView {
  final String titre;
  final String message;
  final TypeAlerte type;

  const AlertCardView({
    required this.titre,
    required this.message,
    required this.type,
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    final couleur = _getCouleur();
    final icone = _getIcone();
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: couleur.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: couleur.withOpacity(0.3), width: 1),
      ),
      child: Row(
        children: [
          Icon(icone, color: couleur, size: 24),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titre,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: couleur,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  message,
                  style: TextStyle(fontSize: 14, color: Colors.black87),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getCouleur() {
    switch (type) {
      case TypeAlerte.critique:
        return Colors.red;
      case TypeAlerte.avertissement:
        return Colors.orange;
      case TypeAlerte.info:
        return Colors.blue;
      case TypeAlerte.succes:
        return Colors.green;
    }
  }

  IconData _getIcone() {
    switch (type) {
      case TypeAlerte.critique:
        return Icons.error;
      case TypeAlerte.avertissement:
        return Icons.warning;
      case TypeAlerte.info:
        return Icons.info;
      case TypeAlerte.succes:
        return Icons.check_circle;
    }
  }
}
