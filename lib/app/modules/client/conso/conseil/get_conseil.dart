import 'package:flutter/material.dart';
import 'package:gaz_connect/app/modules/client/conso/conseil/conseilData.dart';
import 'package:gaz_connect/app/modules/client/conso/conseil/conseil_controller.dart';
import 'package:get/get.dart';

Widget getConseilsSemaine(ConseilsController controller) {
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
          // Titre principal
          const Text(
            'Conseils de la Semaine',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 8),

          // Sous-titre avec nombre d'actions
          Obx(
            () => Text(
              controller.titreSection,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ),

          const SizedBox(height: 20),

          // Liste des conseils
          Obx(
            () => controller.isLoading.value
                ? _buildLoadingState()
                : _buildConseilsList(controller),
          ),

          const SizedBox(height: 20),

          // Bouton Export PDF (exactement comme l'image)
          Obx(
            () => SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: controller.isExporting.value
                    ? null
                    : () => controller.exporterRapportPDF(),
                icon: controller.isExporting.value
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : const Icon(Icons.picture_as_pdf, size: 18),
                label: Text(
                  controller.isExporting.value
                      ? 'Export en cours...'
                      : 'Exporter Rapport PDF',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(
                    0xFF1976D2,
                  ), // ✅ Bleu comme dans l'image
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildLoadingState() {
  return const SizedBox(
    height: 150,
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 12),
          Text(
            'Chargement des conseils...',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
    ),
  );
}

Widget _buildConseilsList(ConseilsController controller) {
  if (controller.conseils.isEmpty) {
    return SizedBox(
      height: 150,
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.lightbulb_outline, size: 40, color: Colors.grey),
            SizedBox(height: 8),
            Text(
              'Aucun conseil disponible',
              style: TextStyle(color: Colors.grey, fontSize: 14),
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

  return Column(
    children: controller.conseils.asMap().entries.map((entry) {
      int index = entry.key;
      ConseilData conseil = entry.value;
      bool isLast = index == controller.conseils.length - 1;

      return Column(
        children: [
          _buildConseilItem(conseil, controller),
          if (!isLast)
            Divider(color: Colors.grey[200], height: 32, thickness: 1),
        ],
      );
    }).toList(),
  );
}

Widget _buildConseilItem(ConseilData conseil, ConseilsController controller) {
  return InkWell(
    onTap: () => controller.toggleConseil(conseil.id),
    borderRadius: BorderRadius.circular(8),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Checkbox (exactement comme l'image)
          Container(
            margin: const EdgeInsets.only(top: 2),
            child: Icon(
              conseil.estComplete
                  ? Icons.check_circle
                  : Icons.radio_button_unchecked,
              color: conseil.estComplete ? Colors.green : Colors.grey[400],
              size: 20,
            ),
          ),

          const SizedBox(width: 12),

          // Contenu du conseil
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Titre du conseil
                Text(
                  conseil.titre,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: conseil.estComplete
                        ? Colors.grey[500]
                        : Colors.black87,
                    decoration: conseil.estComplete
                        ? TextDecoration.lineThrough
                        : null,
                  ),
                ),

                const SizedBox(height: 4),

                // Description
                Text(
                  conseil.description,
                  style: TextStyle(
                    fontSize: 13,
                    color: conseil.estComplete
                        ? Colors.grey[400]
                        : Colors.grey[600],
                  ),
                ),

                const SizedBox(height: 8),

                // Économie avec icône (exactement comme l'image)
                Row(
                  children: [
                    const Icon(
                      Icons.monetization_on,
                      color: Colors.orange,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      conseil.economieFormatee,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.orange,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
