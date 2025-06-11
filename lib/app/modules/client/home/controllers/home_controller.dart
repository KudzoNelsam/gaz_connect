// controllers/home_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/network/impl/client_service.dart';
import '../models/home_data.dart';

class HomeController extends GetxController {
  final ClientService clientService = Get.find<ClientServiceImpl>();

  final Rx<HomeDtoPage?> _homeData = Rx<HomeDtoPage?>(null);
  final RxBool isLoading = false.obs;
  final RxInt selectedBouteilleIndex = 0.obs;
  final RxInt doublePressCount = 0.obs;

  HomeDtoPage? get homeData => _homeData.value;
  BouteilleResponseDto? get selectedBouteille =>
      homeData?.bouteilles.isNotEmpty == true
          ? homeData!.bouteilles[selectedBouteilleIndex.value]
          : null;

  @override
  void onInit() {
    super.onInit();
    loadHomeData();
  }

  Future<void> loadHomeData() async {
    try {
      isLoading.value = true;
      final data = await clientService.getHomeData();
      _homeData.value = data;
    } catch (e) {
      Get.snackbar('Erreur', 'Impossible de charger les données');
    } finally {
      isLoading.value = false;
    }
  }

  void selectBouteille(int index) {
    selectedBouteilleIndex.value = index;
  }

  Future<void> couperGaz() async {
    if (selectedBouteille == null) return;

    doublePressCount.value++;

    if (doublePressCount.value == 1) {
      Get.snackbar(
        'Sécurité',
        'Appuyez une seconde fois pour confirmer',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );

      // Reset après 3 secondes
      Future.delayed(const Duration(seconds: 3), () {
        doublePressCount.value = 0;
      });
      return;
    }

    // Deuxième pression - couper le gaz
    try {
      final success = await clientService.couperGaz(selectedBouteille!.id);

      if (success) {
        Get.snackbar(
          'Gaz coupé',
          'Le gaz a été coupé avec succès',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF10B981),
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Erreur',
          'Impossible de couper le gaz',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } finally {
      doublePressCount.value = 0;
    }
  }

  Future<void> refreshData() async {
    await loadHomeData();
  }
}