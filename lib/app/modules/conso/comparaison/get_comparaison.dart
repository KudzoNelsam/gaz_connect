import 'package:flutter/material.dart';
import 'package:gaz_connect/app/modules/conso/comparaison/comparaison_controller.dart';
import 'package:get/get.dart';

Widget getComparison(ComparisonController controller) {
  return Container(
    margin: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: const Color(
        0xFFF0FFF4,
      ), // ✅ Fond vert très clair comme dans l'image
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: const Color(0xFFB8E6C1), // ✅ Bordure vert clair
        width: 1,
      ),
    ),
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Titre avec icône (exactement comme l'image)
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.compare_arrows,
                  color: Colors.white,
                  size: 16,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Comparaison',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const Spacer(),
              // Bouton refresh optionnel
              IconButton(
                onPressed: () => controller.refresh(),
                icon: const Icon(Icons.refresh, size: 16, color: Colors.grey),
                constraints: const BoxConstraints(),
                padding: EdgeInsets.zero,
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Contenu de la comparaison
          Obx(
            () => controller.isLoading.value
                ? _buildLoadingState()
                : controller.hasComparisonData
                ? _buildComparisonContent(controller)
                : _buildEmptyState(),
          ),
        ],
      ),
    ),
  );
}

Widget _buildLoadingState() {
  return const SizedBox(
    height: 100,
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Colors.green),
          SizedBox(height: 8),
          Text(
            'Calcul de la comparaison...',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
    ),
  );
}

Widget _buildEmptyState() {
  return Container(
    height: 100,
    child: const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 32, color: Colors.grey),
          SizedBox(height: 8),
          Text(
            'Données de comparaison non disponibles',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          Text('nelsam12', style: TextStyle(color: Colors.grey, fontSize: 10)),
        ],
      ),
    ),
  );
}

Widget _buildComparisonContent(ComparisonController controller) {
  return Column(
    children: [
      // Votre consommation
      _buildComparisonRow(
        'Votre consommation',
        controller.votreConsommationFormatted,
        Colors.black87,
        FontWeight.w600,
      ),

      const SizedBox(height: 16),

      // Moyenne similaire
      _buildComparisonRow(
        'Moyenne similaire',
        controller.moyenneSimilaireFormatted,
        Colors.black87,
        FontWeight.w500,
      ),

      const SizedBox(height: 20),

      // Barre de performance (exactement comme l'image)
      Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.green, // ✅ Fond vert comme dans l'image
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          controller.messagePersonnalise,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ),

      // Message supplémentaire optionnel
      const SizedBox(height: 12),
      Text(
        controller.getConseilEconomie(),
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey[600],
          fontStyle: FontStyle.italic,
        ),
        textAlign: TextAlign.center,
      ),
    ],
  );
}

Widget _buildComparisonRow(
  String label,
  String valeur,
  Color couleur,
  FontWeight poids,
) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        label,
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey[700],
          fontWeight: FontWeight.w400,
        ),
      ),
      Text(
        valeur,
        style: TextStyle(fontSize: 16, color: couleur, fontWeight: poids),
      ),
    ],
  );
}
