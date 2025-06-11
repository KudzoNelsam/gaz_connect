import 'package:gaz_connect/app/routes/app_pages.dart';
import 'package:get/get.dart';

class NavigationController extends GetxController {
  var currentIndex = 0.obs; // Index observable pour la BottomNavigationBar
  var currentRoute = Routes.CLIENT_HOME.obs; // Route actuelle

  @override
  void onInit() {
    super.onInit();
    // Initialiser avec la route actuelle si elle existe
    final current = Get.currentRoute;
    if (current.isNotEmpty) {
      currentRoute.value = current;
    }
  }

  void changePage(int index, List<String> labels) {
    if (index >= 0 && index < labels.length) {
      currentIndex.value = index;
      final route = labels[index];

      print('Navigating to: $route');

      // Utiliser offAllNamed pour remplacer la page actuelle
      // et éviter l'empilement des pages
      if (route != currentRoute.value) {
        currentRoute.value = route;
        Get.offAllNamed(route);
      }
    }
  }

  // Obtenir l'index actuel en fonction de la route
  int getIndexForRoute(String route, List<String> labels) {
    final index = labels.indexOf(route);
    return index != -1 ? index : 0;
  }

  // Méthode utilitaire pour mettre à jour la route sans navigation
  void updateCurrentRoute(String route, List<String> labels) {
    currentRoute.value = route;
    final index = labels.indexOf(route);
    if (index != -1) {
      currentIndex.value = index;
    }
  }
}