import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SecuritySettingsController extends GetxController {
  // Variables réactives pour chaque paramètre
  var coupureAutomatique = false.obs;
  var alertesFuite = false.obs;
  var appelsUrgence = false.obs;

  // Map pour stocker tous les paramètres
  var allSettings = <String, bool>{}.obs;

  // Méthodes pour récupérer les valeurs individuelles (avec noms plus clairs)
  bool get isCoupureAutomatiqueEnabled => coupureAutomatique.value;
  bool get isAlertesFuiteEnabled => alertesFuite.value; // Nom plus simple
  bool get isAppelsUrgenceEnabled => appelsUrgence.value;

  // Ou encore plus simple :
  bool get coupureActive => coupureAutomatique.value;
  bool get alertesActives => alertesFuite.value;
  bool get urgenceActive => appelsUrgence.value;

  // Méthode pour mettre à jour les paramètres
  void updateSettings(Map<String, bool> settings) {
    allSettings.value = settings;

    // Mettre à jour les variables individuelles
    coupureAutomatique.value = settings['Coupure automatique'] ?? false;
    alertesFuite.value = settings['Alertes de fuite'] ?? false;
    appelsUrgence.value = settings['Appels d\'urgence'] ?? false;

    // Sauvegarder en local storage si nécessaire
    _saveSettings();

    print('Settings updated: $settings');
  }

  // Méthodes individuelles pour changer chaque paramètre
  void toggleCoupureAutomatique() {
    coupureAutomatique.value = !coupureAutomatique.value;
    _updateAllSettings();
  }

  void toggleAlertesFuite() {
    alertesFuite.value = !alertesFuite.value;
    _updateAllSettings();
  }

  void toggleAppelsUrgence() {
    appelsUrgence.value = !appelsUrgence.value;
    _updateAllSettings();
  }

  void _updateAllSettings() {
    allSettings.value = {
      'Coupure automatique': coupureAutomatique.value,
      'Alertes de fuite': alertesFuite.value,
      'Appels d\'urgence': appelsUrgence.value,
    };
    _saveSettings();
  }

  // Méthode pour récupérer tous les paramètres
  Map<String, bool> getAllSettings() {
    return allSettings.value;
  }

  // Sauvegarder les paramètres
  void _saveSettings() {
    // Ici vous pouvez sauvegarder dans SharedPreferences, Base de données, etc.
    print('Saving settings: ${allSettings.value}');
  }

  // Charger les paramètres sauvegardés
  void loadSettings() {
    // Exemple : charger depuis le stockage local
    // Pour l'instant, on initialise avec des valeurs par défaut
    allSettings.value = {
      'Coupure automatique': false,
      'Alertes de fuite': false,
      'Appels d\'urgence': false,
    };
  }

  @override
  void onInit() {
    super.onInit();
    loadSettings();
  }
}
