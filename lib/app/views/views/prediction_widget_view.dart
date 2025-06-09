import 'package:flutter/material.dart';

import 'package:get/get.dart';

class PredictionWidgetView extends GetView {
  final String titre;
  final String date;
  final String heure;
  final Color couleurAccent;
  final IconData icone;
  const PredictionWidgetView({
    required this.titre,
    required this.date,
    required this.heure,
    required this.couleurAccent,
    required this.icone,
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border(left: BorderSide(color: couleurAccent, width: 4)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            // Icône
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: couleurAccent.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icone, color: couleurAccent, size: 20),
            ),
            SizedBox(width: 12),
            // Contenu texte
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titre,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    date,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: couleurAccent,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    heure,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
