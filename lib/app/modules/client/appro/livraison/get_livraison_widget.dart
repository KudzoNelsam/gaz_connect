import 'package:flutter/material.dart';
import 'package:gaz_connect/app/modules/client/appro/livraison/livraison_controller.dart';
import 'package:get/get.dart';

Widget getLivraisonWidget(LivraisonController controller) {
  return Column(
    children: [
      _buildCommandeAutomatique(controller),
      const SizedBox(height: 16),
      Obx(
        () => controller.aLivraisonEnCours
            ? _buildLivraisonEnCours(controller)
            : const SizedBox.shrink(),
      ),
    ],
  );
}

Widget _buildCommandeAutomatique(LivraisonController controller) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border(left: BorderSide(color: Colors.blue, width: 4)),
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
      child: Obx(
        () => controller.isLoading.value
            ? const SizedBox(
                height: 60,
                child: Center(child: CircularProgressIndicator()),
              )
            : Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Commande automatique',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Obx(
                          () => Text(
                            controller.commandeAutomatique.value?.description ??
                                'Non configuré',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Obx(
                    () => Switch(
                      value: controller.commandeAutomatiqueActive,
                      onChanged: controller.isUpdating.value
                          ? null
                          : (_) => controller.toggleCommandeAutomatique(),
                      activeColor: Colors.blue,
                      activeTrackColor: Colors.blue.withOpacity(0.3),
                      inactiveThumbColor: Colors.grey[400],
                      inactiveTrackColor: Colors.grey[300],
                    ),
                  ),
                ],
              ),
      ),
    ),
  );
}

Widget _buildLivraisonEnCours(LivraisonController controller) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 16),
    decoration: BoxDecoration(
      color: const Color(0xFFF0F8FF),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: const Color(0xFFB8D4F0), width: 1),
    ),
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Titre avec badge statut
          Row(
            children: [
              Icon(Icons.local_shipping, color: Colors.blue, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Livraison en cours',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const Spacer(),
              Obx(
                () => Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color:
                        controller.livraisonEnCours.value?.couleurStatut ??
                        Colors.blue,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    controller.statutLivraison,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Fournisseur
          Obx(
            () => Text(
              controller.livraisonEnCours.value?.fournisseur ?? '',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),

          const SizedBox(height: 12),

          // ETA
          Row(
            children: [
              Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 6),
              Obx(
                () => Text(
                  'ETA: ${controller.livraisonEnCours.value?.eta ?? ''}',
                  style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Adresse
          Row(
            children: [
              Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 6),
              Expanded(
                child: Obx(
                  () => Text(
                    controller.livraisonEnCours.value?.adresse ?? '',
                    style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Progression
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Progression',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  Obx(
                    () => Text(
                      controller.livraisonEnCours.value?.progressionFormatee ??
                          '0%',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Obx(
                () => LinearProgressIndicator(
                  value: controller.livraisonEnCours.value?.progression ?? 0.0,
                  backgroundColor: Colors.grey[300],
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                  minHeight: 6,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // ✅ BOUTON SANS EFFET DE SURVOL/CLIC
          SizedBox(
            width: double.infinity,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => controller.suivreEnTempsReel(),
                borderRadius: BorderRadius.circular(8),
                // ✅ Supprime complètement les effets visuels
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                hoverColor: Colors.transparent,
                focusColor: Colors.transparent,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue, width: 1),
                    borderRadius: BorderRadius.circular(8),
                    // ✅ Garde le fond transparent
                    color: Colors.transparent,
                  ),
                  child: const Text(
                    'Suivre en temps réel',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
