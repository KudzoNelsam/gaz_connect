import 'package:gaz_connect/app/routes/app_pages.dart';
import 'package:get/get.dart';

class NavigationController extends GetxController {
  var currentIndex = 0.obs; // Index observable pour la BottomNavigationBar
  var currentRoute = Routes.HOME.obs; // Route actuelle pour suivre la page

  // Associe les labels des éléments de navigation aux routes
  final Map<String, String> routeMap = {
    Routes.HOME: Routes.HOME,
    Routes.SECURITE: Routes.SECURITE,
    Routes.CONSO: Routes.CONSO,
    Routes.APPRO: Routes.APPRO,
    Routes.SETTINGS: Routes.SETTINGS,
  };

  void changePage(int index, List<String> labels) {
    if (index >= 0 && index < labels.length) {
      currentIndex.value = index;
      final route = routeMap[labels[index]];
      print(route);
      if (route != null) {
        currentRoute.value = route;
        Get.toNamed(route);
      }
    }
  }

  // Obtenir l'index actuel en fonction de la route
  int getIndexForRoute(String route, List<String> labels) {
    String? label;
    for (var entry in routeMap.entries) {
      if (entry.value == route) {
        label = entry.key;
        break;
      }
    }
    return label != null ? labels.indexOf(label) : 0;
  }
}
