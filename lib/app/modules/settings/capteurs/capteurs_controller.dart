import 'package:flutter/material.dart';
import 'package:gaz_connect/app/modules/settings/capteurs/capteurs_data.dart';
import 'package:get/get.dart';

class CapteursController extends GetxController {
  var capteurs = <CapteurData>[].obs;
  var isLoading = false.obs;
  var isRefreshing = false.obs;
  var isEditing = false.obs;

  // Controllers pour l'édition
  final TextEditingController nomController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController zoneController = TextEditingController();

  // Getters
  int get nombreCapteurs => capteurs.length;
  int get capteursActifs =>
      capteurs.where((c) => c.statut == CapteurStatut.actif).length;
  int get capteursAttention =>
      capteurs.where((c) => c.statut == CapteurStatut.attention).length;
  int get capteursCritiques =>
      capteurs.where((c) => c.statut == CapteurStatut.critique).length;

  List<CapteurData> get capteursParStatut {
    List<CapteurData> sorted = List.from(capteurs);
    sorted.sort((a, b) {
      if (a.statut == CapteurStatut.critique &&
          b.statut != CapteurStatut.critique) {
        return -1;
      }
      if (b.statut == CapteurStatut.critique &&
          a.statut != CapteurStatut.critique) {
        return 1;
      }
      if (a.statut == CapteurStatut.attention &&
          b.statut == CapteurStatut.actif) {
        return -1;
      }
      if (b.statut == CapteurStatut.attention &&
          a.statut == CapteurStatut.actif) {
        return 1;
      }
      return 0;
    });
    return sorted;
  }

  @override
  void onInit() {
    super.onInit();
    print('[2025-06-09 13:40:46] nelsam12 - Initialisation CapteursController');
    loadCapteurs();
  }

  @override
  void onClose() {
    nomController.dispose();
    descriptionController.dispose();
    zoneController.dispose();
    super.onClose();
  }

  Future<void> loadCapteurs() async {
    isLoading.value = true;

    try {
      await _loadTestCapteurs();
      print(
        '[2025-06-09 13:40:46] nelsam12 - Capteurs chargés: ${capteurs.length}',
      );
    } catch (e) {
      print('[2025-06-09 13:40:46] nelsam12 - Erreur chargement capteurs: $e');
      _loadFallbackCapteurs();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadTestCapteurs() async {
    await Future.delayed(const Duration(milliseconds: 700));

    capteurs.value = [
      CapteurData(
        id: 'capteur_terrasse_004',
        nom: 'Terrasse',
        description: 'Terrasse extérieure',
        zone: 'Zone D',
        niveauBatterie: 45.0, // ✅ Attention
        statut: CapteurStatut.attention,
        derniereActivite: DateTime.now().subtract(const Duration(minutes: 8)),
        dateDerniereMessage: DateTime.now().subtract(
          const Duration(minutes: 4),
        ),
        estConnecte: true,
        type: TypeCapteur.gaz,
      ),
      CapteurData(
        id: 'capteur_cuisine_001',
        nom: 'Cuisine',
        description: 'Cuisine principale',
        zone: 'Zone A',
        niveauBatterie: 89.0,
        statut: CapteurStatut.actif,
        derniereActivite: DateTime.now().subtract(const Duration(minutes: 5)),
        dateDerniereMessage: DateTime.now().subtract(
          const Duration(minutes: 1),
        ),
        estConnecte: true,
        type: TypeCapteur.gaz,
      ),
      CapteurData(
        id: 'capteur_restaurant_002',
        nom: 'Restaurant',
        description: 'Salle principale',
        zone: 'Zone B',
        niveauBatterie: 76.0,
        statut: CapteurStatut.actif,
        derniereActivite: DateTime.now().subtract(const Duration(minutes: 3)),
        dateDerniereMessage: DateTime.now().subtract(
          const Duration(minutes: 2),
        ),
        estConnecte: true,
        type: TypeCapteur.gaz,
      ),
      CapteurData(
        id: 'capteur_bar_003',
        nom: 'Bar',
        description: 'Comptoir bar',
        zone: 'Zone C',
        niveauBatterie: 92.0,
        statut: CapteurStatut.actif,
        derniereActivite: DateTime.now().subtract(const Duration(minutes: 1)),
        dateDerniereMessage: DateTime.now(),
        estConnecte: true,
        type: TypeCapteur.gaz,
      ),
    ];
  }

  void _loadFallbackCapteurs() {
    capteurs.value = [
      CapteurData(
        id: 'fallback',
        nom: 'Capteur par défaut',
        description: 'Aucune donnée disponible',
        zone: 'Inconnu',
        niveauBatterie: 0.0,
        statut: CapteurStatut.horsLigne,
        derniereActivite: DateTime.now(),
        dateDerniereMessage: DateTime.now(),
        estConnecte: false,
        type: TypeCapteur.gaz,
      ),
    ];
  }

  // ✅ FONCTION PRINCIPALE D'ÉDITION
  void editerCapteur(String capteurId) {
    final capteur = capteurs.firstWhereOrNull((c) => c.id == capteurId);
    if (capteur == null) {
      print('[2025-06-09 13:40:46] nelsam12 - Capteur non trouvé: $capteurId');
      return;
    }

    print(
      '[2025-06-09 13:40:46] nelsam12 - Ouverture édition capteur: ${capteur.nom}',
    );

    // Pré-remplir les champs avec les données actuelles
    nomController.text = capteur.nom;
    descriptionController.text = capteur.description;
    zoneController.text = capteur.zone;

    // Ouvrir le dialogue d'édition
    _ouvrirDialogueEdition(capteur);
  }

  // ✅ DIALOGUE D'ÉDITION COMPLET
  void _ouvrirDialogueEdition(CapteurData capteur) {
    Get.dialog(
      AlertDialog(
        title: Row(
          children: [
            Icon(Icons.edit, color: Colors.blue, size: 24),
            const SizedBox(width: 8),
            const Text('Modifier le capteur'),
          ],
        ),
        content: SizedBox(
          width: Get.width * 0.85,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Informations actuelles
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Informations actuelles:',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: capteur.couleurStatut,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              capteur.labelStatut,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Batterie: ${capteur.batterieFormatee}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Champ Nom
                TextField(
                  controller: nomController,
                  decoration: InputDecoration(
                    labelText: 'Nom du capteur',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: const Icon(Icons.sensors, color: Colors.blue),
                  ),
                ),

                const SizedBox(height: 16),

                // Champ Description
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: const Icon(
                      Icons.description,
                      color: Colors.blue,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Champ Zone
                TextField(
                  controller: zoneController,
                  decoration: InputDecoration(
                    labelText: 'Zone',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: const Icon(
                      Icons.location_on,
                      color: Colors.blue,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Informations techniques
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue[200]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.info, color: Colors.blue[700], size: 16),
                          const SizedBox(width: 6),
                          Text(
                            'Informations techniques:',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.blue[700],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'ID: ${capteur.id}',
                        style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                      ),
                      Text(
                        'Type: ${capteur.type.label}',
                        style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                      ),
                      Text(
                        'Dernière activité: ${_formatDateTime(capteur.derniereActivite)}',
                        style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                      ),
                      Text(
                        'Modifié par: nelsam12',
                        style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
              _viderChamps();
            },
            child: const Text('Annuler'),
          ),
          Obx(
            () => ElevatedButton(
              onPressed: isEditing.value
                  ? null
                  : () => _sauvegarderModifications(capteur),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: isEditing.value
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text('Sauvegarder'),
            ),
          ),
        ],
      ),
    );
  }

  // ✅ SAUVEGARDER LES MODIFICATIONS
  Future<void> _sauvegarderModifications(CapteurData capteurOriginal) async {
    isEditing.value = true;

    try {
      // Validation des champs
      if (nomController.text.trim().isEmpty) {
        Get.snackbar(
          'Erreur de validation',
          'Le nom du capteur ne peut pas être vide',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      if (descriptionController.text.trim().isEmpty) {
        Get.snackbar(
          'Erreur de validation',
          'La description ne peut pas être vide',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      // Simulation d'appel API
      await Future.delayed(const Duration(milliseconds: 1200));

      // TODO: Remplacer par appel API réel
      // await ApiService.updateCapteur(capteurOriginal.id, {
      //   'nom': nomController.text.trim(),
      //   'description': descriptionController.text.trim(),
      //   'zone': zoneController.text.trim(),
      //   'modifiePar': 'nelsam12',
      //   'dateModification': DateTime.now().toIso8601String(),
      // });

      // Mettre à jour localement
      final index = capteurs.indexWhere((c) => c.id == capteurOriginal.id);
      if (index != -1) {
        capteurs[index] = CapteurData(
          id: capteurOriginal.id,
          nom: nomController.text.trim(),
          description: descriptionController.text.trim(),
          zone: zoneController.text.trim(),
          niveauBatterie: capteurOriginal.niveauBatterie,
          statut: capteurOriginal.statut,
          derniereActivite: DateTime.now(), // ✅ Mise à jour timestamp
          dateDerniereMessage: capteurOriginal.dateDerniereMessage,
          estConnecte: capteurOriginal.estConnecte,
          type: capteurOriginal.type,
        );
      }

      Get.back(); // Fermer le dialogue
      _viderChamps();

      Get.snackbar(
        'Capteur modifié',
        'Les informations de "${nomController.text.trim()}" ont été sauvegardées - nelsam12',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        icon: const Icon(Icons.check_circle, color: Colors.white),
        duration: const Duration(seconds: 3),
      );

      print(
        '[2025-06-09 13:40:46] nelsam12 - Capteur ${capteurOriginal.id} modifié avec succès',
      );
    } catch (e) {
      print('[2025-06-09 13:40:46] nelsam12 - Erreur sauvegarde capteur: $e');
      Get.snackbar(
        'Erreur de sauvegarde',
        'Impossible de sauvegarder les modifications',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        icon: const Icon(Icons.error, color: Colors.white),
      );
    } finally {
      isEditing.value = false;
    }
  }

  void _viderChamps() {
    nomController.clear();
    descriptionController.clear();
    zoneController.clear();
  }

  // ✅ FORMATAGE DE LA DATE/HEURE
  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return 'Il y a ${difference.inDays} jour${difference.inDays > 1 ? 's' : ''}';
    } else if (difference.inHours > 0) {
      return 'Il y a ${difference.inHours} heure${difference.inHours > 1 ? 's' : ''}';
    } else if (difference.inMinutes > 0) {
      return 'Il y a ${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''}';
    } else {
      return 'À l\'instant';
    }
  }

  // ✅ FONCTIONS UTILITAIRES SUPPLÉMENTAIRES

  Map<String, dynamic> getStatistiques() {
    return {
      'total': nombreCapteurs,
      'actifs': capteursActifs,
      'attention': capteursAttention,
      'critiques': capteursCritiques,
      'batterieMoyenne': _getBatterieMoyenne(),
    };
  }

  double _getBatterieMoyenne() {
    if (capteurs.isEmpty) return 0.0;
    double total = capteurs.fold(
      0.0,
      (sum, capteur) => sum + capteur.niveauBatterie,
    );
    return total / capteurs.length;
  }

  void actualiserStatutsCapteurs() {
    for (int i = 0; i < capteurs.length; i++) {
      final capteur = capteurs[i];
      CapteurStatut nouveauStatut;

      if (capteur.niveauBatterie >= 50) {
        nouveauStatut = CapteurStatut.actif;
      } else if (capteur.niveauBatterie >= 20) {
        nouveauStatut = CapteurStatut.attention;
      } else {
        nouveauStatut = CapteurStatut.critique;
      }

      if (nouveauStatut != capteur.statut) {
        capteurs[i] = CapteurData(
          id: capteur.id,
          nom: capteur.nom,
          description: capteur.description,
          zone: capteur.zone,
          niveauBatterie: capteur.niveauBatterie,
          statut: nouveauStatut,
          derniereActivite: capteur.derniereActivite,
          dateDerniereMessage: DateTime.now(),
          estConnecte: capteur.estConnecte,
          type: capteur.type,
        );
      }
    }
  }

  // ✅ SUPPRIMER UN CAPTEUR
  void supprimerCapteur(String capteurId) {
    final capteur = capteurs.firstWhereOrNull((c) => c.id == capteurId);
    if (capteur == null) return;

    Get.dialog(
      AlertDialog(
        title: const Text('Supprimer le capteur'),
        content: Text(
          'Êtes-vous sûr de vouloir supprimer "${capteur.nom}" ?\n\nCette action est irréversible.',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Annuler')),
          TextButton(
            onPressed: () {
              capteurs.removeWhere((c) => c.id == capteurId);
              Get.back();

              Get.snackbar(
                'Capteur supprimé',
                '${capteur.nom} a été supprimé - nelsam12',
                backgroundColor: Colors.orange,
                colorText: Colors.white,
                icon: const Icon(Icons.delete, color: Colors.white),
              );

              print(
                '[2025-06-09 13:40:46] nelsam12 - Capteur ${capteur.nom} supprimé',
              );
            },
            child: const Text('Supprimer', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // ✅ Refresh manuel
  @override
  Future<void> refresh() async {
    print('[2025-06-09 13:40:46] nelsam12 - Refresh des données capteurs');
    isRefreshing.value = true;
    await loadCapteurs();
    actualiserStatutsCapteurs();
    isRefreshing.value = false;
  }
}
