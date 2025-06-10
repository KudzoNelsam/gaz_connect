import 'package:flutter/material.dart';
import 'package:gaz_connect/app/modules/settings/userProfile/user_profile_controller.dart';
import 'package:get/get.dart';

Widget getUserProfileWidget(UserProfileController controller) {
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
          // Titre avec icône (exactement comme l'image)
          Row(
            children: [
              Icon(Icons.person, color: Colors.blue, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Profil Utilisateur',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Contenu du profil
          Obx(
            () => controller.isLoading.value
                ? _buildLoadingState()
                : controller.hasUserProfile
                ? _buildProfileContent(controller)
                : _buildEmptyState(),
          ),
        ],
      ),
    ),
  );
}

Widget _buildLoadingState() {
  return const SizedBox(
    height: 80,
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 8),
          Text(
            'Chargement du profil...',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
    ),
  );
}

Widget _buildEmptyState() {
  return SizedBox(
    height: 80,
    child: const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person_off, size: 32, color: Colors.grey),
          SizedBox(height: 8),
          Text(
            'Profil non disponible',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
    ),
  );
}

Widget _buildProfileContent(UserProfileController controller) {
  return Row(
    children: [
      // ✅ Avatar circulaire avec initiales (exactement comme l'image)
      GestureDetector(
        onTap: () => controller.changerPhotoProfil(),
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: controller.couleurAvatar, // ✅ Couleur générée
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              controller.initialesUtilisateur, // ✅ "MD" comme dans l'image
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),

      const SizedBox(width: 16),

      // Informations utilisateur
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nom complet (exactement comme l'image)
            Text(
              controller.nomUtilisateur, // ✅ "Mamadou Diallo"
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 4),

            // Téléphone (exactement comme l'image)
            Text(
              controller.telephoneUtilisateur, // ✅ "+221 77 XXX XX XX"
              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
            ),
          ],
        ),
      ),

      // ✅ Bouton d'édition (exactement comme l'image)
      GestureDetector(
        onTap: () {
          print('[2025-06-09 12:52:38] nelsam12 - Clic sur édition profil');
          controller.ouvrirEditionProfil();
        },
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(Icons.edit, size: 20, color: Colors.grey[600]),
        ),
      ),
    ],
  );
}
