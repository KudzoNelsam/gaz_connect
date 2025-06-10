import 'package:flutter/material.dart';
import 'package:gaz_connect/app/modules/client/conso/conseil/conseilData.dart';
import 'package:get/get.dart';

class ConseilsController extends GetxController {
  var conseils = <ConseilData>[].obs;
  var isLoading = false.obs;
  var isExporting = false.obs;

  int get nombreConseils => conseils.length;
  String get titreSection => '$nombreConseils actions pour économiser';

  double get economieTotal =>
      conseils.fold(0.0, (sum, conseil) => sum + conseil.economieEstimee);
  String get economieTotalFormatee =>
      '${economieTotal.toStringAsFixed(0)} FCFA/mois';

  List<ConseilData> get conseilsActifs =>
      conseils.where((c) => !c.estComplete).toList();
  List<ConseilData> get conseilsCompletes =>
      conseils.where((c) => c.estComplete).toList();

  @override
  void onInit() {
    super.onInit();
    print('[2025-06-09 12:19:36] nelsam12 - Initialisation ConseilsController');
    loadConseils();
  }

  // ✅ Méthode principale - facile à remplacer par l'API plus tard
  Future<void> loadConseils() async {
    isLoading.value = true;

    try {
      // TODO: Remplacer par l'appel API
      // final response = await ApiService.getConseils('nelsam12');
      // conseils.value = response.data.map((item) => ConseilData.fromJson(item)).toList();

      // ✅ DONNÉES DE TEST RÉALISTES (exactement comme votre image)
      await _loadTestConseils();

      print(
        '[2025-06-09 12:19:36] nelsam12 - Conseils chargés: ${conseils.length}',
      );
    } catch (e) {
      print('[2025-06-09 12:19:36] nelsam12 - Erreur chargement conseils: $e');
      _loadFallbackConseils();
    } finally {
      isLoading.value = false;
    }
  }

  // ✅ DONNÉES DE TEST - exactement comme votre image
  Future<void> _loadTestConseils() async {
    // Simulation délai réseau
    await Future.delayed(const Duration(milliseconds: 400));

    conseils.value = [
      ConseilData(
        id: '1',
        titre: 'Réduire le feu en fin de cuisson',
        description: 'Économie estimée: 15% par mois',
        economieEstimee: 450.0,
        unite: 'FCFA',
        periode: 'mois',
        type: ConseilType.cuisine,
        priorite: ConseilPriorite.haute,
        dateCreation: DateTime.now().subtract(const Duration(days: 1)),
        icone: Icons.local_fire_department,
      ),
      ConseilData(
        id: '2',
        titre: 'Utiliser des couvercles',
        description: 'Cuisson 25% plus rapide',
        economieEstimee: 300.0,
        unite: 'FCFA',
        periode: 'mois',
        type: ConseilType.cuisine,
        priorite: ConseilPriorite.moyenne,
        dateCreation: DateTime.now().subtract(const Duration(days: 2)),
        icone: Icons.kitchen,
      ),
      ConseilData(
        id: '3',
        titre: 'Entretenir les brûleurs',
        description: 'Nettoyage hebdomadaire recommandé',
        economieEstimee: 200.0,
        unite: 'FCFA',
        periode: 'mois',
        type: ConseilType.entretien,
        priorite: ConseilPriorite.moyenne,
        dateCreation: DateTime.now().subtract(const Duration(days: 3)),
        icone: Icons.cleaning_services,
      ),
    ];
  }

  void _loadFallbackConseils() {
    conseils.value = [
      ConseilData(
        id: 'fallback',
        titre: 'Aucun conseil disponible',
        description: 'Veuillez réessayer plus tard',
        economieEstimee: 0.0,
        type: ConseilType.utilisation,
        dateCreation: DateTime.now(),
      ),
    ];
  }

  // ✅ Marquer un conseil comme complété
  void toggleConseil(String conseilId) {
    final index = conseils.indexWhere((c) => c.id == conseilId);
    if (index != -1) {
      final conseil = conseils[index];
      conseils[index] = ConseilData(
        id: conseil.id,
        titre: conseil.titre,
        description: conseil.description,
        economieEstimee: conseil.economieEstimee,
        unite: conseil.unite,
        periode: conseil.periode,
        type: conseil.type,
        priorite: conseil.priorite,
        estComplete: !conseil.estComplete,
        dateCreation: conseil.dateCreation,
        icone: conseil.icone,
      );

      print(
        '[2025-06-09 12:19:36] nelsam12 - Conseil ${conseil.titre} ${conseil.estComplete ? 'décoché' : 'complété'}',
      );
    }
  }

  // ✅ Export PDF
  Future<void> exporterRapportPDF() async {
    if (isExporting.value) return;

    isExporting.value = true;
    print('[2025-06-09 12:19:36] nelsam12 - Début export rapport PDF');

    try {
      // Simulation de l'export PDF
      await Future.delayed(const Duration(seconds: 2));

      // TODO: Implémenter l'export PDF réel
      // await PDFService.generateConseilsReport(conseils, 'nelsam12');

      Get.snackbar(
        'Export réussi',
        'Le rapport PDF a été généré avec succès - nelsam12',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        icon: const Icon(Icons.check_circle, color: Colors.white),
      );

      print('[2025-06-09 12:19:36] nelsam12 - Export PDF terminé avec succès');
    } catch (e) {
      print('[2025-06-09 12:19:36] nelsam12 - Erreur export PDF: $e');
      Get.snackbar(
        'Erreur d\'export',
        'Impossible de générer le rapport PDF',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        icon: const Icon(Icons.error, color: Colors.white),
      );
    } finally {
      isExporting.value = false;
    }
  }

  // ✅ Statistiques
  Map<ConseilType, int> getStatistiquesParType() {
    Map<ConseilType, int> stats = {};
    for (var conseil in conseils) {
      stats[conseil.type] = (stats[conseil.type] ?? 0) + 1;
    }
    return stats;
  }

  double getEconomieParType(ConseilType type) {
    return conseils
        .where((c) => c.type == type)
        .fold(0.0, (sum, conseil) => sum + conseil.economieEstimee);
  }

  // ✅ MÉTHODE POUR LE FUTUR BACKEND
  /*
  Future<void> loadFromBackend() async {
    try {
      isLoading.value = true;
      
      final response = await http.get(
        Uri.parse('$baseUrl/api/conseils'),
        headers: {
          'Authorization': 'Bearer $userToken',
          'Content-Type': 'application/json',
        },
        queryParameters: {
          'userId': 'nelsam12',
          'semaine': _getCurrentWeek(),
        },
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        conseils.value = (data['conseils'] as List)
            .map((item) => ConseilData.fromJson(item))
            .toList();
            
        print('[2025-06-09 12:19:36] nelsam12 - Conseils backend chargés: ${conseils.length}');
      } else {
        throw Exception('Erreur API: ${response.statusCode}');
      }
      
    } catch (e) {
      print('[2025-06-09 12:19:36] nelsam12 - Erreur backend conseils: $e');
      _loadFallbackConseils();
    } finally {
      isLoading.value = false;
    }
  }
  */

  // ✅ Refresh manuel
  @override
  Future<void> refresh() async {
    print('[2025-06-09 12:19:36] nelsam12 - Refresh des conseils');
    await loadConseils();
  }
}
