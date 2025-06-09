import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gaz_connect/app/modules/conso/comparaison/comparaison_data.dart';
import 'package:get/get.dart';

class ComparisonController extends GetxController {
  var comparisonData = Rx<ComparisonData?>(null);
  var isLoading = false.obs;
  var selectedType = ComparisonType.quotidienne.obs;

  // Getters pour l'affichage
  String get votreConsommationFormatted => comparisonData.value != null
      ? '${comparisonData.value!.votreConsommation.toStringAsFixed(1)} ${comparisonData.value!.unite}'
      : '-- kg/jour';

  String get moyenneSimilaireFormatted => comparisonData.value != null
      ? '${comparisonData.value!.moyenneSimilaire.toStringAsFixed(1)} ${comparisonData.value!.unite}'
      : '-- kg/jour';

  String get messageComparaison =>
      comparisonData.value?.performance.message ?? '';
  Color get couleurComparaison =>
      comparisonData.value?.performance.color ?? Colors.grey;

  String get messagePersonnalise {
    if (comparisonData.value == null) return '';

    double pourcentage = comparisonData.value!.pourcentageDifference.abs();
    String direction = comparisonData.value!.performance.messagePersonnalise;

    return '${pourcentage.toStringAsFixed(0)}% $direction';
  }

  bool get hasComparisonData => comparisonData.value != null;

  @override
  void onInit() {
    super.onInit();
    print(
      '[2025-06-09 12:13:52] nelsam12 - Initialisation ComparisonController',
    );
    loadComparisonData();
  }

  void changeType(ComparisonType nouveauType) {
    selectedType.value = nouveauType;
    print(
      '[2025-06-09 12:13:52] nelsam12 - Changement type comparaison: ${nouveauType.name}',
    );
    loadComparisonData();
  }

  // ✅ Méthode principale - facile à remplacer par l'API plus tard
  Future<void> loadComparisonData() async {
    isLoading.value = true;

    try {
      // TODO: Remplacer par l'appel API
      // final response = await ApiService.getComparison('nelsam12', selectedType.value);
      // comparisonData.value = ComparisonData.fromJson(response.data);

      // ✅ DONNÉES DE TEST RÉALISTES (exactement comme votre image)
      await _loadTestComparisonData();

      print('[2025-06-09 12:13:52] nelsam12 - Données comparaison chargées');
    } catch (e) {
      print(
        '[2025-06-09 12:13:52] nelsam12 - Erreur chargement comparaison: $e',
      );
      _loadFallbackComparisonData();
    } finally {
      isLoading.value = false;
    }
  }

  // ✅ DONNÉES DE TEST - exactement comme votre image
  Future<void> _loadTestComparisonData() async {
    // Simulation délai réseau
    await Future.delayed(const Duration(milliseconds: 500));

    if (selectedType.value == ComparisonType.quotidienne) {
      // Données exactes de votre image
      comparisonData.value = ComparisonData(
        votreConsommation: 2.1, // Votre consommation
        moyenneSimilaire: 2.8, // Moyenne similaire
        unite: 'kg/jour',
        periode: 'jour',
        dateCalcul: DateTime.now(),
        type: ComparisonType.quotidienne,
      );
    } else if (selectedType.value == ComparisonType.hebdomadaire) {
      comparisonData.value = ComparisonData(
        votreConsommation: 14.7,
        moyenneSimilaire: 19.6,
        unite: 'kg/semaine',
        periode: 'semaine',
        dateCalcul: DateTime.now(),
        type: ComparisonType.hebdomadaire,
      );
    } else {
      comparisonData.value = ComparisonData(
        votreConsommation: 63.0,
        moyenneSimilaire: 84.0,
        unite: 'kg/mois',
        periode: 'mois',
        dateCalcul: DateTime.now(),
        type: ComparisonType.mensuelle,
      );
    }
  }

  void _loadFallbackComparisonData() {
    comparisonData.value = ComparisonData(
      votreConsommation: 0.0,
      moyenneSimilaire: 0.0,
      unite: 'kg/jour',
      periode: 'jour',
      dateCalcul: DateTime.now(),
      type: selectedType.value,
    );
  }

  // ✅ Méthodes utilitaires
  double getPourcentageEconomie() {
    if (comparisonData.value == null) return 0.0;
    return comparisonData.value!.pourcentageDifference.abs();
  }

  bool estEconomique() {
    return comparisonData.value?.estMeilleur ?? false;
  }

  String getConseilEconomie() {
    if (comparisonData.value == null) return '';

    if (estEconomique()) {
      return 'Excellente gestion ! Continuez ainsi.';
    } else {
      double diff = comparisonData.value!.difference;
      return 'Vous pouvez économiser ${diff.toStringAsFixed(1)} ${comparisonData.value!.unite}.';
    }
  }

  // ✅ MÉTHODE POUR LE FUTUR BACKEND
  /*
  Future<void> loadFromBackend() async {
    try {
      isLoading.value = true;
      
      final response = await http.get(
        Uri.parse('$baseUrl/api/comparison'),
        headers: {
          'Authorization': 'Bearer $userToken',
          'Content-Type': 'application/json',
        },
        queryParameters: {
          'userId': 'nelsam12',
          'type': selectedType.value.name,
          'period': _getPeriodForAPI(),
        },
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        comparisonData.value = ComparisonData.fromJson(data['comparison']);
        
        print('[2025-06-09 12:13:52] nelsam12 - Données comparaison backend chargées');
      } else {
        throw Exception('Erreur API: ${response.statusCode}');
      }
      
    } catch (e) {
      print('[2025-06-09 12:13:52] nelsam12 - Erreur backend comparaison: $e');
      _loadFallbackComparisonData();
    } finally {
      isLoading.value = false;
    }
  }
  */

  // ✅ Refresh manuel
  Future<void> refresh() async {
    print('[2025-06-09 12:13:52] nelsam12 - Refresh des données comparaison');
    await loadComparisonData();
  }
}
