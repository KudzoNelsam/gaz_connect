import 'package:flutter/material.dart';
import 'package:gaz_connect/app/core/network/user_connected.dart';
import 'package:gaz_connect/app/modules/technicien/home/views/components/welcome_card.dart';
import 'package:gaz_connect/app/routes/app_pages.dart';

import 'package:get/get.dart';

import '../controllers/technicien_home_controller.dart';
import 'components/client_management_screen.dart';

class TechnicienHomeView extends GetView<TechnicienController> {
  const TechnicienHomeView({super.key});
  @override
  Widget build(BuildContext context) {
    final UserConnected userConnected = UserConnected.getUserConnected()!;
    return Scaffold(
      appBar: AppBar(title: const Text('GazConnect'), centerTitle: true, actions: [
        IconButton(
          onPressed: _showLogoutDialog,
          icon: const Icon(Icons.logout),
          tooltip: 'Déconnexion',
        ),
      ],),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            WelcomeCard(userName: userConnected.nomComplet, clientCount: 3),
            const SizedBox(height: 16),
            // Permet à la liste de prendre tout l'espace restant et d'être scrollable
            Expanded(
              child: ClientManagementScreen(),
            )
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Déconnexion'),
        content: const Text('Êtes-vous sûr de vouloir vous déconnecter ?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back(); // Fermer le dialog
              _logout(); // Effectuer la déconnexion
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Déconnexion'),
          ),
        ],
      ),
    );
  }

  void _logout() {
    // Logique de déconnexion (supprimer tokens, etc.)
    // Exemple avec votre AuthService :
    // Get.find<AuthService>().logout();

    // Rediriger vers la page de connexion
    Get.offAllNamed(Routes.LOGIN); // ou votre route de login

    Get.snackbar(
      'Déconnexion',
      'Vous avez été déconnecté avec succès',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}