import 'package:gaz_connect/app/modules/client/conso/charts/consumption_data.dart';
import 'package:get/get.dart';

class ConsumptionController extends GetxController {
  var selectedPeriod = 7.obs;
  var consumptionData = <ConsumptionData>[].obs;
  var isLoading = false.obs;

  // ✅ Structure pour le futur backend
  String get apiEndpoint => '/api/consumption';
  String get userId => 'nelsam12';

  List<ConsumptionPeriod> get periods => [
    ConsumptionPeriod(
      label: '7 jours',
      jours: 7,
      isSelected: selectedPeriod.value == 7,
    ),
    ConsumptionPeriod(
      label: '30 jours',
      jours: 30,
      isSelected: selectedPeriod.value == 30,
    ),
    ConsumptionPeriod(
      label: '90 jours',
      jours: 90,
      isSelected: selectedPeriod.value == 90,
    ),
  ];

  String get currentTitle => 'Consommation - ${selectedPeriod.value} jours';
  String get unite => 'kg';

  double get maxValue {
    if (consumptionData.isEmpty) return 4.0;
    double max = consumptionData
        .map((d) => d.valeur)
        .reduce((a, b) => a > b ? a : b);
    return (max * 1.2).roundToDouble(); // 20% de marge + arrondi
  }

  @override
  void onInit() {
    super.onInit();
    print(
      '[2025-06-09 12:01:28] nelsam12 - Initialisation ConsumptionController',
    );
    loadConsumptionData();
  }

  void changePeriod(int nouvellePeriode) {
    selectedPeriod.value = nouvellePeriode;
    print(
      '[2025-06-09 12:01:28] nelsam12 - Changement période: $nouvellePeriode jours',
    );
    loadConsumptionData();
  }

  // ✅ Méthode principale - facile à remplacer par l'API plus tard
  Future<void> loadConsumptionData() async {
    isLoading.value = true;

    try {
      // TODO: Remplacer par l'appel API
      // final response = await ApiService.getConsumption(userId, selectedPeriod.value);
      // consumptionData.value = response.data;

      // ✅ DONNÉES DE TEST RÉALISTES (à remplacer)
      await _loadTestData();

      print(
        '[2025-06-09 12:01:28] nelsam12 - Données chargées: ${consumptionData.length} points pour ${selectedPeriod.value} jours',
      );
    } catch (e) {
      print('[2025-06-09 12:01:28] nelsam12 - Erreur chargement données: $e');
      _loadFallbackData();
    } finally {
      isLoading.value = false;
    }
  }

  // ✅ DONNÉES DE TEST - exactement comme votre image
  Future<void> _loadTestData() async {
    // Simulation délai réseau
    await Future.delayed(const Duration(milliseconds: 800));

    if (selectedPeriod.value == 7) {
      // Données de la semaine (comme dans votre image)
      consumptionData.value = [
        ConsumptionData(
          periode: 'Lun',
          valeur: 2.3,
          unite: unite,
          date: _getDateForDay(6),
        ),
        ConsumptionData(
          periode: 'Mar',
          valeur: 1.8,
          unite: unite,
          date: _getDateForDay(5),
        ),
        ConsumptionData(
          periode: 'Mer',
          valeur: 2.0,
          unite: unite,
          date: _getDateForDay(4),
        ),
        ConsumptionData(
          periode: 'Jeu',
          valeur: 2.4,
          unite: unite,
          date: _getDateForDay(3),
        ),
        ConsumptionData(
          periode: 'Ven',
          valeur: 2.8,
          unite: unite,
          date: _getDateForDay(2),
        ),
        ConsumptionData(
          periode: 'Sam',
          valeur: 3.2,
          unite: unite,
          date: _getDateForDay(1),
        ),
        ConsumptionData(
          periode: 'Dim',
          valeur: 2.7,
          unite: unite,
          date: _getDateForDay(0),
        ),
      ];
    } else if (selectedPeriod.value == 30) {
      // Données mensuelles (par semaine)
      consumptionData.value = [
        ConsumptionData(
          periode: 'S1',
          valeur: 16.5,
          unite: unite,
          date: _getDateForDay(21),
        ),
        ConsumptionData(
          periode: 'S2',
          valeur: 18.2,
          unite: unite,
          date: _getDateForDay(14),
        ),
        ConsumptionData(
          periode: 'S3',
          valeur: 15.8,
          unite: unite,
          date: _getDateForDay(7),
        ),
        ConsumptionData(
          periode: 'S4',
          valeur: 17.1,
          unite: unite,
          date: _getDateForDay(0),
        ),
      ];
    } else {
      // Données trimestrielles (par mois)
      consumptionData.value = [
        ConsumptionData(
          periode: 'Mar',
          valeur: 65.4,
          unite: unite,
          date: _getDateForDay(60),
        ),
        ConsumptionData(
          periode: 'Avr',
          valeur: 72.1,
          unite: unite,
          date: _getDateForDay(30),
        ),
        ConsumptionData(
          periode: 'Mai',
          valeur: 68.9,
          unite: unite,
          date: _getDateForDay(0),
        ),
      ];
    }
  }

  // ✅ Données de secours en cas d'erreur
  void _loadFallbackData() {
    consumptionData.value = [
      ConsumptionData(
        periode: 'Erreur',
        valeur: 0.0,
        unite: unite,
        date: DateTime.now(),
      ),
    ];
  }

  DateTime _getDateForDay(int daysAgo) {
    return DateTime.now().subtract(Duration(days: daysAgo));
  }

  // ✅ Statistiques calculées
  double getTotalConsumption() {
    return consumptionData.fold(0.0, (sum, data) => sum + data.valeur);
  }

  double getAverageConsumption() {
    if (consumptionData.isEmpty) return 0.0;
    return getTotalConsumption() / consumptionData.length;
  }

  double getMaxConsumption() {
    if (consumptionData.isEmpty) return 0.0;
    return consumptionData.map((d) => d.valeur).reduce((a, b) => a > b ? a : b);
  }

  double getMinConsumption() {
    if (consumptionData.isEmpty) return 0.0;
    return consumptionData.map((d) => d.valeur).reduce((a, b) => a < b ? a : b);
  }

  // ✅ MÉTHODE POUR LE FUTUR BACKEND
  /*
  Future<void> loadFromBackend() async {
    try {
      isLoading.value = true;
      
      final response = await http.get(
        Uri.parse('$baseUrl$apiEndpoint'),
        headers: {
          'Authorization': 'Bearer $userToken',
          'Content-Type': 'application/json',
        },
        queryParameters: {
          'userId': userId,
          'period': selectedPeriod.value.toString(),
          'startDate': _getStartDate().toIso8601String(),
          'endDate': DateTime.now().toIso8601String(),
        },
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        consumptionData.value = (data['consumption'] as List)
            .map((item) => ConsumptionData.fromJson(item))
            .toList();
            
        print('[2025-06-09 12:01:28] nelsam12 - Données backend chargées: ${consumptionData.length}');
      } else {
        throw Exception('Erreur API: ${response.statusCode}');
      }
      
    } catch (e) {
      print('[2025-06-09 12:01:28] nelsam12 - Erreur backend: $e');
      _loadFallbackData();
    } finally {
      isLoading.value = false;
    }
  }
  
  DateTime _getStartDate() {
    return DateTime.now().subtract(Duration(days: selectedPeriod.value));
  }
  */

  // ✅ Refresh manuel
  @override
  Future<void> refresh() async {
    print('[2025-06-09 12:01:28] nelsam12 - Refresh des données');
    await loadConsumptionData();
  }
}
