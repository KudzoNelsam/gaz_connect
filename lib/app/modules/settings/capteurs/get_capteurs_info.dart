import 'package:flutter/material.dart';
import 'package:gaz_connect/app/modules/settings/capteurs/capteurs_controller.dart';
import 'package:gaz_connect/app/modules/settings/capteurs/capteurs_data.dart';
import 'package:get/get.dart';

Widget getCapteursWidget(CapteursController controller) {
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
          // ✅ Titre SANS bouton (exactement comme votre demande)
          Row(
            children: [
              Icon(Icons.sensors, color: Colors.blue, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Mes Capteurs',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              // ✅ PAS DE BOUTON "Ajouter" comme demandé
            ],
          ),

          const SizedBox(height: 20),

          // Liste des capteurs
          Obx(
            () => controller.isLoading.value
                ? _buildLoadingState()
                : _buildCapteursList(controller),
          ),
        ],
      ),
    ),
  );
}

Widget _buildLoadingState() {
  return const SizedBox(
    height: 200,
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 12),
          Text(
            'Chargement des capteurs...',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
    ),
  );
}

Widget _buildCapteursList(CapteursController controller) {
  if (controller.capteurs.isEmpty) {
    return SizedBox(
      height: 150,
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.sensors_off, size: 40, color: Colors.grey),
            SizedBox(height: 8),
            Text(
              'Aucun capteur configuré',
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
    children: controller.capteursParStatut.asMap().entries.map((entry) {
      int index = entry.key;
      CapteurData capteur = entry.value;
      bool isLast = index == controller.capteurs.length - 1;

      return Column(
        children: [
          _buildCapteurItem(capteur, controller),
          if (!isLast)
            Divider(color: Colors.grey[200], height: 32, thickness: 1),
        ],
      );
    }).toList(),
  );
}

Widget _buildCapteurItem(CapteurData capteur, CapteursController controller) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      children: [
        // Informations du capteur
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Nom du capteur (exactement comme l'image)
              Text(
                capteur.nom,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 4),

              // Description (exactement comme l'image)
              Text(
                capteur.description,
                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
              ),
            ],
          ),
        ),

        // Section droite: Batterie + Statut + Édition
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Niveau de batterie (exactement comme l'image)
            Text(
              'Batterie: ${capteur.batterieFormatee}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 8),

            // Badge statut et icône d'édition
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ✅ Badge statut (exactement comme l'image)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: capteur.couleurStatut,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    capteur.labelStatut,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // ✅ Icône d'édition (exactement comme l'image)
                GestureDetector(
                  onTap: () {
                    print(
                      '[2025-06-09 13:16:59] nelsam12 - Édition capteur: ${capteur.nom}',
                    );
                    controller.editerCapteur(capteur.id);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    child: Icon(Icons.edit, size: 18, color: Colors.grey[600]),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  );
}
