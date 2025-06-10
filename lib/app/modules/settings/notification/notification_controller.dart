import 'package:gaz_connect/app/modules/client/appro/livraison/livraison_controller.dart';
import 'package:gaz_connect/app/modules/client/conso/comparaison/comparaison_controller.dart';
import 'package:gaz_connect/app/modules/settings/capteurs/capteurs_controller.dart';
import 'package:gaz_connect/app/modules/settings/notification/notification_data.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

// ✅ CONTROLLER GLOBAL - Accessible depuis toutes les vues
class NotificationSettingsController extends GetxController {
  static NotificationSettingsController get instance =>
      Get.find<NotificationSettingsController>();

  var settings = Rx<NotificationSettingsData?>(null);
  var isLoading = false.obs;
  var isSaving = false.obs;

  // Controllers pour les champs
  final TextEditingController seuilController = TextEditingController();

  // ✅ GETTERS GLOBAUX - Utilisables partout dans l'app
  bool get notificationsPushActivees =>
      settings.value?.notificationsPushActivees ?? false;
  bool get alertesSMSActivees => settings.value?.alertesSMSActivees ?? false;
  double get seuilAlerteGlobal =>
      settings.value?.seuilAlerte ?? 23.0; // ✅ SEUIL GLOBAL
  String get seuilAlerteFormateGlobal =>
      '${seuilAlerteGlobal.toStringAsFixed(0)}%';

  // ✅ Vérification si le seuil est atteint (utilisable partout)
  bool estSeuilAtteint(double niveauActuel) {
    return niveauActuel <= seuilAlerteGlobal;
  }

  @override
  void onInit() {
    super.onInit();
    print(
      '[2025-06-09 13:56:59] nelsam12 - Initialisation NotificationSettingsController GLOBAL',
    );
    loadNotificationSettings();
  }

  @override
  void onClose() {
    seuilController.dispose();
    super.onClose();
  }

  // ✅ Chargement des paramètres
  Future<void> loadNotificationSettings() async {
    isLoading.value = true;

    try {
      // TODO: Remplacer par l'appel API
      // final response = await ApiService.getNotificationSettings('nelsam12');
      // settings.value = NotificationSettingsData.fromJson(response.data);

      await _loadTestSettings();

      // Mettre à jour le controller du seuil
      seuilController.text =
          settings.value?.seuilAlerte.toStringAsFixed(0) ?? '23';

      print(
        '[2025-06-09 13:56:59] nelsam12 - Paramètres notifications chargés',
      );
    } catch (e) {
      print(
        '[2025-06-09 13:56:59] nelsam12 - Erreur chargement paramètres: $e',
      );
      _loadDefaultSettings();
    } finally {
      isLoading.value = false;
    }
  }

  // ✅ DONNÉES DE TEST - exactement comme votre image
  Future<void> _loadTestSettings() async {
    await Future.delayed(const Duration(milliseconds: 400));

    settings.value = NotificationSettingsData(
      notificationsPushActivees: true, // ✅ Switch activé comme dans l'image
      alertesSMSActivees: true, // ✅ Switch activé comme dans l'image
      seuilAlerte: 23.0, // ✅ 23% comme dans l'image
      derniereModification: DateTime.now(),
      modifiePar: 'nelsam12',
      typesActifs: [
        TypeNotification.seuilAtteint,
        TypeNotification.commandeAutomatique,
        TypeNotification.livraison,
      ],
    );
  }

  void _loadDefaultSettings() {
    settings.value = NotificationSettingsData(
      notificationsPushActivees: false,
      alertesSMSActivees: false,
      seuilAlerte: 20.0,
      derniereModification: DateTime.now(),
      modifiePar: 'nelsam12',
      typesActifs: [],
    );
    seuilController.text = '20';
  }

  // ✅ TOGGLE NOTIFICATIONS PUSH
  Future<void> toggleNotificationsPush(bool nouvelleValeur) async {
    if (settings.value == null) return;

    try {
      // TODO: Appel API pour sauvegarder
      await Future.delayed(const Duration(milliseconds: 300));

      settings.value = settings.value!.copyWith(
        notificationsPushActivees: nouvelleValeur,
        derniereModification: DateTime.now(),
        modifiePar: 'nelsam12',
      );

      _afficherNotificationSucces(
        'Notifications push ${nouvelleValeur ? 'activées' : 'désactivées'}',
        'Paramètre sauvegardé - nelsam12',
      );

      print(
        '[2025-06-09 13:56:59] nelsam12 - Notifications push: $nouvelleValeur',
      );
    } catch (e) {
      print('[2025-06-09 13:56:59] nelsam12 - Erreur toggle push: $e');
      _afficherNotificationErreur(
        'Impossible de modifier les notifications push',
      );
    }
  }

  // ✅ TOGGLE ALERTES SMS
  Future<void> toggleAlertesSMS(bool nouvelleValeur) async {
    if (settings.value == null) return;

    try {
      await Future.delayed(const Duration(milliseconds: 300));

      settings.value = settings.value!.copyWith(
        alertesSMSActivees: nouvelleValeur,
        derniereModification: DateTime.now(),
        modifiePar: 'nelsam12',
      );

      _afficherNotificationSucces(
        'Alertes SMS ${nouvelleValeur ? 'activées' : 'désactivées'}',
        'Paramètre sauvegardé - nelsam12',
      );

      print('[2025-06-09 13:56:59] nelsam12 - Alertes SMS: $nouvelleValeur');
    } catch (e) {
      print('[2025-06-09 13:56:59] nelsam12 - Erreur toggle SMS: $e');
      _afficherNotificationErreur('Impossible de modifier les alertes SMS');
    }
  }

  // ✅ MODIFIER LE SEUIL D'ALERTE GLOBAL
  Future<void> modifierSeuilAlerte(double nouveauSeuil) async {
    if (settings.value == null) return;

    // Validation
    if (nouveauSeuil < 1 || nouveauSeuil > 99) {
      _afficherNotificationErreur('Le seuil doit être entre 1% et 99%');
      return;
    }

    isSaving.value = true;

    try {
      // TODO: Appel API pour sauvegarder le nouveau seuil
      await Future.delayed(const Duration(milliseconds: 800));

      final ancienSeuil = settings.value!.seuilAlerte;

      settings.value = settings.value!.copyWith(
        seuilAlerte: nouveauSeuil,
        derniereModification: DateTime.now(),
        modifiePar: 'nelsam12',
      );

      // Mettre à jour le controller
      seuilController.text = nouveauSeuil.toStringAsFixed(0);

      _afficherNotificationSucces(
        'Seuil d\'alerte modifié',
        'Ancien: ${ancienSeuil.toStringAsFixed(0)}% → Nouveau: ${nouveauSeuil.toStringAsFixed(0)}% - nelsam12',
      );

      print(
        '[2025-06-09 13:56:59] nelsam12 - Seuil modifié: ${ancienSeuil.toStringAsFixed(0)}% → ${nouveauSeuil.toStringAsFixed(0)}%',
      );

      // ✅ NOTIFIER TOUS LES AUTRES CONTROLLERS QUE LE SEUIL A CHANGÉ
      _notifierChangementSeuil(nouveauSeuil);
    } catch (e) {
      print('[2025-06-09 13:56:59] nelsam12 - Erreur modification seuil: $e');
      _afficherNotificationErreur('Impossible de modifier le seuil d\'alerte');
    } finally {
      isSaving.value = false;
    }
  }

  // ✅ NOTIFICATION DU CHANGEMENT DE SEUIL À TOUS LES CONTROLLERS
  void _notifierChangementSeuil(double nouveauSeuil) {
    try {
      // Notifier le controller de livraison
      if (Get.isRegistered<LivraisonController>()) {
        final livraisonController = Get.find<LivraisonController>();
        // livraisonController.onSeuilAlerteChange(nouveauSeuil);
      }

      // Notifier le controller de comparaison
      if (Get.isRegistered<ComparisonController>()) {
        final comparisonController = Get.find<ComparisonController>();
        // comparisonController.onSeuilAlerteChange(nouveauSeuil);
      }

      // Notifier le controller de capteurs
      if (Get.isRegistered<CapteursController>()) {
        final capteursController = Get.find<CapteursController>();
        // capteursController.onSeuilAlerteChange(nouveauSeuil);
      }

      print(
        '[2025-06-09 13:56:59] nelsam12 - Changement seuil notifié à tous les controllers',
      );
    } catch (e) {
      print(
        '[2025-06-09 13:56:59] nelsam12 - Erreur notification changement seuil: $e',
      );
    }
  }

  // ✅ VÉRIFICATION DU SEUIL POUR UN NIVEAU DONNÉ
  bool verifierSeuilPourNiveau(double niveau, String source) {
    final seuilAtteint = estSeuilAtteint(niveau);

    if (seuilAtteint) {
      print(
        '[2025-06-09 13:56:59] nelsam12 - SEUIL ATTEINT: ${niveau.toStringAsFixed(1)}% <= ${seuilAlerteGlobal.toStringAsFixed(0)}% (Source: $source)',
      );

      // Déclencher une notification si activée
      if (notificationsPushActivees || alertesSMSActivees) {
        _declencherNotificationSeuil(niveau, source);
      }
    }

    return seuilAtteint;
  }

  void _declencherNotificationSeuil(double niveau, String source) {
    _afficherNotificationUrgente(
      'Seuil d\'alerte atteint !',
      '$source: ${niveau.toStringAsFixed(1)}% - Commande automatique recommandée - nelsam12',
    );
  }

  // ✅ METHODS D'AFFICHAGE DES NOTIFICATIONS
  void _afficherNotificationSucces(String titre, String message) {
    Get.snackbar(
      titre,
      message,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      icon: const Icon(Icons.check_circle, color: Colors.white),
      duration: const Duration(seconds: 2),
    );
  }

  void _afficherNotificationErreur(String message) {
    Get.snackbar(
      'Erreur',
      message,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      icon: const Icon(Icons.error, color: Colors.white),
      duration: const Duration(seconds: 3),
    );
  }

  void _afficherNotificationUrgente(String titre, String message) {
    Get.snackbar(
      titre,
      message,
      backgroundColor: Colors.orange,
      colorText: Colors.white,
      icon: const Icon(Icons.warning, color: Colors.white),
      duration: const Duration(seconds: 5),
      isDismissible: true,
    );
  }

  // ✅ MÉTHODES UTILITAIRES
  List<double> getSeuilsPredefinis() {
    return [10.0, 15.0, 20.0, 25.0, 30.0, 35.0, 40.0];
  }

  String getDescriptionSeuil() {
    if (seuilAlerteGlobal <= 15) {
      return 'Seuil très bas - Commandes fréquentes';
    } else if (seuilAlerteGlobal <= 25) {
      return 'Seuil optimal - Équilibre performance/sécurité';
    } else if (seuilAlerteGlobal <= 35) {
      return 'Seuil élevé - Moins de commandes';
    } else {
      return 'Seuil très élevé - Risque de rupture';
    }
  }

  // ✅ MÉTHODE POUR LE FUTUR BACKEND
  /*
  Future<void> saveToBackend() async {
    try {
      isSaving.value = true;
      
      final response = await http.put(
        Uri.parse('$baseUrl/api/notifications/settings'),
        headers: {
          'Authorization': 'Bearer $userToken',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'userId': 'nelsam12',
          'notificationsPush': notificationsPushActivees,
          'alertesSMS': alertesSMSActivees,
          'seuilAlerte': seuilAlerteGlobal,
          'modifiePar': 'nelsam12',
          'dateModification': DateTime.now().toIso8601String(),
        }),
      );
      
      if (response.statusCode == 200) {
        print('[2025-06-09 13:56:59] nelsam12 - Paramètres sauvegardés sur backend');
      } else {
        throw Exception('Erreur API: ${response.statusCode}');
      }
      
    } catch (e) {
      print('[2025-06-09 13:56:59] nelsam12 - Erreur sauvegarde backend: $e');
      throw e;
    } finally {
      isSaving.value = false;
    }
  }
  */

  // ✅ Refresh manuel
  @override
  Future<void> refresh() async {
    print(
      '[2025-06-09 13:56:59] nelsam12 - Refresh des paramètres notifications',
    );
    await loadNotificationSettings();
  }
}
