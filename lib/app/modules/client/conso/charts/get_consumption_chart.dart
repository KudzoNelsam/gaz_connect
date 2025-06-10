import 'package:flutter/material.dart';
import 'package:gaz_connect/app/modules/client/conso/charts/consumption_controller.dart';
import 'package:get/get.dart';

Widget getConsumptionChart(ConsumptionController controller) {
  return Container(
    margin: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
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
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Boutons de période
          Obx(
            () => Wrap(
              spacing: 8,
              children: controller.periods.map((period) {
                return ElevatedButton(
                  onPressed: () => controller.changePeriod(period.jours),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: period.isSelected
                        ? const Color(0xFF1976D2)
                        : Colors.grey[200],
                    foregroundColor: period.isSelected
                        ? Colors.white
                        : Colors.black54,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: Text(
                    period.label,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 24),

          // Titre avec refresh
          Row(
            children: [
              const Icon(Icons.bar_chart, color: Colors.blue, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Obx(
                  () => Text(
                    controller.currentTitle,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: () => controller.refresh(),
                icon: const Icon(Icons.refresh, size: 20),
                tooltip: 'Actualiser',
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Graphique
          Obx(() => _buildChart(controller)),
        ],
      ),
    ),
  );
}

Widget _buildChart(ConsumptionController controller) {
  if (controller.isLoading.value) {
    return const SizedBox(
      height: 200,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(
              'Chargement des données...',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  if (controller.consumptionData.isEmpty) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bar_chart, size: 48, color: Colors.grey),
            SizedBox(height: 8),
            Text(
              'Aucune donnée disponible',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
            Text(
              'nelsam12',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  return SizedBox(
    height: 200,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Axe Y
        SizedBox(
          width: 35,
          height: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                controller.maxValue.toStringAsFixed(1),
                style: TextStyle(fontSize: 10, color: Colors.grey[600]),
              ),
              Text(
                (controller.maxValue * 0.75).toStringAsFixed(1),
                style: TextStyle(fontSize: 10, color: Colors.grey[600]),
              ),
              Text(
                (controller.maxValue * 0.5).toStringAsFixed(1),
                style: TextStyle(fontSize: 10, color: Colors.grey[600]),
              ),
              Text(
                (controller.maxValue * 0.25).toStringAsFixed(1),
                style: TextStyle(fontSize: 10, color: Colors.grey[600]),
              ),
              Text(
                '0',
                style: TextStyle(fontSize: 10, color: Colors.grey[600]),
              ),
            ],
          ),
        ),

        const SizedBox(width: 8),

        // Barres
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: controller.consumptionData.map((data) {
              double heightRatio = data.valeur / controller.maxValue;
              double barHeight = 150 * heightRatio;

              return Flexible(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Valeur au-dessus de la barre
                    Text(
                      data.valeur.toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),

                    // Barre
                    Container(
                      width: 20,
                      height: barHeight,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1976D2),
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(2),
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Label
                    Text(
                      data.periode,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    ),
  );
}
