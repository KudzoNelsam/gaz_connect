import 'package:flutter/material.dart';
import 'package:gaz_connect/app/modules/appro/livraison/livraison_data.dart';
import 'package:get/get.dart';
import 'dart:async';

class LivraisonController extends GetxController {
  var commandeAutomatique = Rx<CommandeAutomatiqueData?>(null);
  var livraisonEnCours = Rx<LivraisonData?>(null);
  var isLoading = false.obs;
  var isUpdating = false.obs;

  // Getters
  bool get aCommandeAutomatique => commandeAutomatique.value != null;
  bool get commandeAutomatiqueActive =>
      commandeAutomatique.value?.estActive ?? false;

  bool get aLivraisonEnCours => livraisonEnCours.value != null;
  String get statutLivraison => livraisonEnCours.value?.labelStatut ?? '';

  @override
  void onInit() {
    super.onInit();
    print(
      '[2025-06-09 12:41:59] nelsam12 - Initialisation LivraisonController',
    );
    loadLivraisonData();
    _startPeriodicUpdate();
  }

  Future<void> loadLivraisonData() async {
    isLoading.value = true;

    try {
      await _loadTestLivraisonData();
      print('[2025-06-09 12:41:59] nelsam12 - Données livraison chargées');
    } catch (e) {
      print('[2025-06-09 12:41:59] nelsam12 - Erreur chargement livraison: $e');
      _loadFallbackData();
    } finally {
      isLoading.value = false;
    }
  }

  // ✅ DONNÉES DE TEST avec timestamp correct
  Future<void> _loadTestLivraisonData() async {
    await Future.delayed(const Duration(milliseconds: 600));

    commandeAutomatique.value = CommandeAutomatiqueData(
      estActive: true,
      seuilPourcentage: 10.0,
      description: 'Seuil: 10% restant',
      derniereCommande: DateTime.now().subtract(const Duration(days: 15)),
      prochainVerification: DateTime.now().add(const Duration(hours: 6)),
    );

    // ✅ Livraison en cours - nelsam12 12:41:59
    livraisonEnCours.value = LivraisonData(
      id: 'LIV20250609124159',
      fournisseur: 'GazPlus Express',
      eta: '14:30',
      adresse: 'Mamadou Diallo - +221 77 XXX XX XX',
      progression: 0.75, // 75%
      statut: LivraisonStatut.enRoute, // ✅ "En livraison" bleu
      dateCommande: DateTime(2025, 6, 9, 10, 41, 59),
      dateEstimee: DateTime(2025, 6, 9, 14, 30, 0),
      numeroSuivi: 'GPE20250609124159',
    );
  }

  void _loadFallbackData() {
    commandeAutomatique.value = CommandeAutomatiqueData(
      estActive: false,
      seuilPourcentage: 10.0,
      description: 'Service indisponible',
      derniereCommande: DateTime.now(),
      prochainVerification: DateTime.now(),
    );
    livraisonEnCours.value = null;
  }

  Future<void> toggleCommandeAutomatique() async {
    if (commandeAutomatique.value == null) return;

    isUpdating.value = true;

    try {
      bool nouvelEtat = !commandeAutomatiqueActive;
      await Future.delayed(const Duration(milliseconds: 800));

      commandeAutomatique.value = CommandeAutomatiqueData(
        estActive: nouvelEtat,
        seuilPourcentage: commandeAutomatique.value!.seuilPourcentage,
        description: commandeAutomatique.value!.description,
        derniereCommande: commandeAutomatique.value!.derniereCommande,
        prochainVerification: DateTime.now().add(const Duration(hours: 6)),
      );

      Get.snackbar(
        'Commande automatique',
        nouvelEtat ? 'Activée avec succès - nelsam12' : 'Désactivée - nelsam12',
        backgroundColor: nouvelEtat ? Colors.green : Colors.orange,
        colorText: Colors.white,
      );

      print(
        '[2025-06-09 12:41:59] nelsam12 - Commande automatique ${nouvelEtat ? 'activée' : 'désactivée'}',
      );
    } catch (e) {
      print('[2025-06-09 12:41:59] nelsam12 - Erreur toggle commande: $e');
    } finally {
      isUpdating.value = false;
    }
  }

  void _startPeriodicUpdate() {
    Timer.periodic(const Duration(seconds: 30), (timer) {
      if (aLivraisonEnCours &&
          livraisonEnCours.value!.statut == LivraisonStatut.enRoute) {
        _updateProgression();
      }
    });
  }

  void _updateProgression() {
    if (livraisonEnCours.value == null) return;

    final livraison = livraisonEnCours.value!;
    double nouvelleProgression = (livraison.progression + 0.02).clamp(0.0, 1.0);

    livraisonEnCours.value = LivraisonData(
      id: livraison.id,
      fournisseur: livraison.fournisseur,
      eta: livraison.eta,
      adresse: livraison.adresse,
      progression: nouvelleProgression,
      statut: nouvelleProgression >= 0.95
          ? LivraisonStatut.proche
          : livraison.statut,
      dateCommande: livraison.dateCommande,
      dateEstimee: livraison.dateEstimee,
      numeroSuivi: livraison.numeroSuivi,
    );
  }

  void suivreEnTempsReel() {
    print('[2025-06-09 12:41:59] nelsam12 - Ouverture suivi temps réel');

    Get.snackbar(
      'Suivi activé',
      'Vous recevrez des notifications en temps réel - nelsam12',
      backgroundColor: Colors.blue,
      colorText: Colors.white,
      icon: const Icon(Icons.notifications_active, color: Colors.white),
    );
  }

  Future<void> refresh() async {
    print('[2025-06-09 12:41:59] nelsam12 - Refresh des données livraison');
    await loadLivraisonData();
  }
}
