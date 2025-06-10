import 'package:flutter/material.dart';
import 'package:gaz_connect/app/modules/client/conso/budget/budget_data.dart';
import 'package:get/get.dart';

class BudgetController extends GetxController {
  var budgetData = Rx<BudgetData?>(null);
  var isLoading = false.obs;
  var selectedPeriod = 30.obs; // 30 jours par défaut

  // Périodes disponibles
  List<int> get periodesDisponibles => [7, 15, 30, 60, 90];
  String get periodLabel => 'Prévision ${selectedPeriod.value} jours';

  // Getters pour l'affichage
  String get budgetPrevuFormatted => budgetData.value != null
      ? '${_formatMontant(budgetData.value!.budgetPrevu)} ${budgetData.value!.devise}'
      : '-- FCFA';

  String get moisActuelFormatted => budgetData.value != null
      ? '${_formatMontant(budgetData.value!.moisActuel)} ${budgetData.value!.devise}'
      : '-- FCFA';

  String get moisDernierFormatted => budgetData.value != null
      ? '${_formatMontant(budgetData.value!.moisDernier)} ${budgetData.value!.devise} ${budgetData.value!.tendance.symbole}'
      : '-- FCFA';

  Color get moisDernierColor => budgetData.value?.tendance.color ?? Colors.grey;

  bool get hasBudgetData => budgetData.value != null;
  bool get estSousLeBudget => budgetData.value?.sousLeBudget ?? false;

  @override
  void onInit() {
    super.onInit();
    print('[2025-06-09 12:05:55] nelsam12 - Initialisation BudgetController');
    loadBudgetData();
  }

  void changePeriod(int nouvellePeriode) {
    selectedPeriod.value = nouvellePeriode;
    print(
      '[2025-06-09 12:05:55] nelsam12 - Changement période budget: $nouvellePeriode jours',
    );
    loadBudgetData();
  }

  // ✅ Méthode principale - facile à remplacer par l'API plus tard
  Future<void> loadBudgetData() async {
    isLoading.value = true;

    try {
      // TODO: Remplacer par l'appel API
      // final response = await ApiService.getBudgetPrevision('nelsam12', selectedPeriod.value);
      // budgetData.value = BudgetData.fromJson(response.data);

      // ✅ DONNÉES DE TEST RÉALISTES (exactement comme votre image)
      await _loadTestBudgetData();

      print(
        '[2025-06-09 12:05:55] nelsam12 - Données budget chargées pour ${selectedPeriod.value} jours',
      );
    } catch (e) {
      print('[2025-06-09 12:05:55] nelsam12 - Erreur chargement budget: $e');
      _loadFallbackBudgetData();
    } finally {
      isLoading.value = false;
    }
  }

  // ✅ DONNÉES DE TEST - exactement comme votre image
  Future<void> _loadTestBudgetData() async {
    // Simulation délai réseau
    await Future.delayed(const Duration(milliseconds: 600));

    if (selectedPeriod.value == 30) {
      // Données exactes de votre image
      budgetData.value = BudgetData(
        periode: '30 jours',
        budgetPrevu: 16200.0,
        moisActuel: 15750.0,
        moisDernier: 17300.0,
        devise: 'FCFA',
        dateCalcul: DateTime.now(),
        tendance: BudgetTendance.baisse, // Car 15750 < 17300
      );
    } else if (selectedPeriod.value == 7) {
      budgetData.value = BudgetData(
        periode: '7 jours',
        budgetPrevu: 4200.0,
        moisActuel: 3850.0,
        moisDernier: 4100.0,
        devise: 'FCFA',
        dateCalcul: DateTime.now(),
        tendance: BudgetTendance.baisse,
      );
    } else if (selectedPeriod.value == 60) {
      budgetData.value = BudgetData(
        periode: '60 jours',
        budgetPrevu: 32400.0,
        moisActuel: 31500.0,
        moisDernier: 30200.0,
        devise: 'FCFA',
        dateCalcul: DateTime.now(),
        tendance: BudgetTendance.hausse,
      );
    } else {
      // Données génériques pour autres périodes
      budgetData.value = BudgetData(
        periode: '${selectedPeriod.value} jours',
        budgetPrevu: selectedPeriod.value * 540.0,
        moisActuel: selectedPeriod.value * 525.0,
        moisDernier: selectedPeriod.value * 577.0,
        devise: 'FCFA',
        dateCalcul: DateTime.now(),
        tendance: BudgetTendance.baisse,
      );
    }
  }

  void _loadFallbackBudgetData() {
    budgetData.value = BudgetData(
      periode: '${selectedPeriod.value} jours',
      budgetPrevu: 0.0,
      moisActuel: 0.0,
      moisDernier: 0.0,
      devise: 'FCFA',
      dateCalcul: DateTime.now(),
      tendance: BudgetTendance.stable,
    );
  }

  String _formatMontant(double montant) {
    // Format français avec espaces pour les milliers
    if (montant >= 1000) {
      return montant
          .toStringAsFixed(0)
          .replaceAllMapped(
            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
            (Match m) => '${m[1]} ',
          );
    }
    return montant.toStringAsFixed(0);
  }

  // ✅ Statistiques supplémentaires
  double getEconomieRealisee() {
    return budgetData.value?.economie ?? 0.0;
  }

  double getPourcentageUtilise() {
    if (budgetData.value == null || budgetData.value!.budgetPrevu == 0) {
      return 0.0;
    }
    return (budgetData.value!.moisActuel / budgetData.value!.budgetPrevu) * 100;
  }

  String getMessageEconomie() {
    double economie = getEconomieRealisee();
    if (economie > 0) {
      return 'Économie de ${_formatMontant(economie)} FCFA';
    } else if (economie < 0) {
      return 'Dépassement de ${_formatMontant(economie.abs())} FCFA';
    } else {
      return 'Budget respecté';
    }
  }

  // ✅ MÉTHODE POUR LE FUTUR BACKEND
  /*
  Future<void> loadFromBackend() async {
    try {
      isLoading.value = true;
      
      final response = await http.get(
        Uri.parse('$baseUrl/api/budget/prevision'),
        headers: {
          'Authorization': 'Bearer $userToken',
          'Content-Type': 'application/json',
        },
        queryParameters: {
          'userId': 'nelsam12',
          'period': selectedPeriod.value.toString(),
          'startDate': _getStartDate().toIso8601String(),
          'endDate': DateTime.now().toIso8601String(),
        },
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        budgetData.value = BudgetData.fromJson(data['budget']);
        
        print('[2025-06-09 12:05:55] nelsam12 - Données budget backend chargées');
      } else {
        throw Exception('Erreur API: ${response.statusCode}');
      }
      
    } catch (e) {
      print('[2025-06-09 12:05:55] nelsam12 - Erreur backend budget: $e');
      _loadFallbackBudgetData();
    } finally {
      isLoading.value = false;
    }
  }
  */

  // ✅ Refresh manuel
  @override
  Future<void> refresh() async {
    print('[2025-06-09 12:05:55] nelsam12 - Refresh des données budget');
    await loadBudgetData();
  }
}
