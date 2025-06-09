import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class GraphiqueDonutView extends GetView {
  final String titre;
  final String sousTitre;
  final double pourcentage;
  final String labelCentre;
  final Color couleurPrincipale;
  final Color? couleurFond;
  const GraphiqueDonutView({
    required this.titre,
    required this.sousTitre,
    required this.pourcentage,
    required this.labelCentre,
    required this.couleurPrincipale,
    required this.couleurFond,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titre,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 4),
          Text(
            sousTitre,
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          SizedBox(height: 20),
          SizedBox(
            height: 100,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(
                  PieChartData(
                    sections: [
                      // Section utilisée
                      PieChartSectionData(
                        value: pourcentage,
                        color: couleurPrincipale,
                        title: '',
                        radius: 10,
                        showTitle: false,
                      ),
                      // Section non utilisée
                      PieChartSectionData(
                        value: 100 - pourcentage,
                        color: couleurFond ?? Colors.grey[300]!,
                        title: '',
                        radius: 10,
                        showTitle: false,
                      ),
                    ],
                    sectionsSpace: 0,
                    centerSpaceRadius: 40,
                    startDegreeOffset: -90,
                  ),
                ),
                // Texte au centre
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${pourcentage.toInt()}%',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: couleurPrincipale,
                      ),
                    ),
                    Text(
                      labelCentre,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
