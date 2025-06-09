import 'package:gaz_connect/app/modules/securite/incidents/incident.dart';
import 'package:get/get.dart';

class IncidentsController extends GetxController {
  var incidents = <Incident>[].obs;

  int get incidentsCount => incidents.length;
  bool get hasIncidents => incidents.isNotEmpty;

  List<Incident> get incidentsRecents => incidents.take(5).toList();

  @override
  void onInit() {
    super.onInit();
    // Incidents par défaut comme dans l'image
    incidents.value = [
      Incident(
        id: '1',
        titre: 'Fuite détectée',
        dateHeure: DateTime(2025, 5, 20, 14, 32),
        duree: const Duration(minutes: 2),
        action: 'Coupure automatique',
        type: IncidentType.fuite,
        status: IncidentStatus.resolu,
      ),
      Incident(
        id: '2',
        titre: 'Niveau critique',
        dateHeure: DateTime(2025, 5, 18, 9, 15),
        duree: const Duration(minutes: 1),
        action: 'Commande automatique',
        type: IncidentType.niveauCritique,
        status: IncidentStatus.resolu,
      ),
      Incident(
        id: '3',
        titre: 'Test capteur',
        dateHeure: DateTime(2025, 5, 15, 16, 0),
        duree: const Duration(seconds: 30),
        action: 'Vérification OK',
        type: IncidentType.testCapteur,
        status: IncidentStatus.resolu,
      ),
    ];

    print(
      '[2025-06-09 09:53:28] nelsam12 - Incidents chargés: ${incidents.length}',
    );
  }

  void ajouterIncident(Incident incident) {
    incidents.insert(0, incident); // Ajouter au début
    print(
      '[2025-06-09 09:53:28] nelsam12 - Nouvel incident: ${incident.titre}',
    );
  }

  void marquerCommeResolu(String incidentId) {
    final index = incidents.indexWhere((i) => i.id == incidentId);
    if (index != -1) {
      final incident = incidents[index];
      incidents[index] = Incident(
        id: incident.id,
        titre: incident.titre,
        dateHeure: incident.dateHeure,
        duree: incident.duree,
        action: incident.action,
        type: incident.type,
        status: IncidentStatus.resolu,
      );
      print(
        '[2025-06-09 09:53:28] nelsam12 - Incident ${incident.titre} marqué comme résolu',
      );
    }
  }
}
