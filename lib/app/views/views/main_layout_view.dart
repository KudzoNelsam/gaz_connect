import 'package:flutter/material.dart';
import 'package:gaz_connect/app/controllers/navigation_controller.dart';
import 'package:get/get.dart';

class MainLayoutView extends GetView<NavigationController> {
  final Widget body;
  final String title;
  final List<BottomNavigationBarItem> items;
  final List<String> itemLabels;

  const MainLayoutView({
    required this.body,
    required this.title,
    required this.items,
    required this.itemLabels,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Mettre à jour la route actuelle quand la page se construit
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentRoute = Get.currentRoute;
      if (itemLabels.contains(currentRoute)) {
        controller.updateCurrentRoute(currentRoute, itemLabels);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _showLogoutDialog,
            icon: const Icon(Icons.logout),
            tooltip: 'Déconnexion',
          ),
        ],
      ),
      body: body,
      bottomNavigationBar: Obx(() => BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFFFF5722),
        unselectedItemColor: Colors.grey,
        items: items,
        currentIndex: controller.getIndexForRoute(
          controller.currentRoute.value,
          itemLabels,
        ),
        onTap: (index) => controller.changePage(index, itemLabels),
      )),
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
              Get.back();
              // Logique de déconnexion
              Get.offAllNamed('/login');
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
}