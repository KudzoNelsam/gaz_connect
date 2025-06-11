import 'dart:ui';

import 'package:get/get.dart';

import '../models/intervention_dto_page.dart';

class TechnicienInterventionsController extends GetxController {
  // État réactif
  final Rx<InterventionDtoPage?> _data = Rx<InterventionDtoPage?>(null);
  final RxBool isLoading = false.obs;

  // Getters
  InterventionDtoPage? get data => _data.value;

  @override
  void onInit() {
    super.onInit();
    loadInterventions();
  }

  static InterventionDtoPage mockData() {
    return InterventionDtoPage(
      totalInterventions: 4,
      completedInterventions: 4,
      interventions: [
        InterventionItem(
          clientName: 'Jean Dupont',
          address: '123 Rue de la Paix, Paris',
          date: '07 juin 2025',
          time: '09:20',
          duration: '45 min',
          type: 'Installation',
          typeColor: const Color(0xFF3B82F6),
          isCompleted: true,
        ),
        InterventionItem(
          clientName: 'Marie Martin',
          address: '456 Avenue des Champs, Lyon',
          date: '06 juin 2025',
          time: '14:30',
          duration: '30 min',
          type: 'Maintenance',
          typeColor: const Color(0xFF10B981),
          isCompleted: true,
        ),
        InterventionItem(
          clientName: 'Pierre Durand',
          address: '789 Boulevard Central, Marseille',
          date: '05 juin 2025',
          time: '11:15',
          duration: '60 min',
          type: 'Configuration',
          typeColor: const Color(0xFFF59E0B),
          isCompleted: true,
        ),
        InterventionItem(
          clientName: 'Sophie Leroux',
          address: '321 Rue Neuve, Nice',
          date: '04 juin 2025',
          time: '16:00',
          duration: '25 min',
          type: 'Changement bouteille',
          typeColor: const Color(0xFF8B5CF6),
          isCompleted: true,
        ),
      ],
    );
  }

  // Méthodes
  Future<void> loadInterventions() async {
    try {
      isLoading.value = true;

      // Simule un appel API
      await Future.delayed(const Duration(milliseconds: 500));

      // Charge les données mock (remplacez par votre appel API)
      _data.value = mockData();

    } catch (e) {
      // Gestion d'erreur
      Get.snackbar(
        'Erreur',
        'Impossible de charger les interventions',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshInterventions() async {
    await loadInterventions();
  }

  void onInterventionTap(InterventionItem intervention) {
    // Logique de navigation ou d'action
    print('Intervention sélectionnée: ${intervention.clientName}');
  }
}