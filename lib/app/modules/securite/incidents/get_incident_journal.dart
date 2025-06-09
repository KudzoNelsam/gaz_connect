import 'package:flutter/material.dart';
import 'package:gaz_connect/app/modules/securite/incidents/incident.dart';
import 'package:gaz_connect/app/modules/securite/incidents/incidents_controller.dart';
import 'package:get/get.dart';

Widget getIncidentsJournal(IncidentsController controller) {
  return Container(
    margin: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          spreadRadius: 1,
          blurRadius: 5,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Titre avec icône (exactement comme l'image)
          Row(
            children: [
              Icon(Icons.access_time, color: Colors.blue, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Journal des Incidents',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Liste des incidents (exactement comme l'image)
          Obx(
            () => controller.hasIncidents
                ? Column(
                    children: controller.incidents.asMap().entries.map((entry) {
                      int index = entry.key;
                      Incident incident = entry.value;
                      bool isLast = index == controller.incidents.length - 1;

                      return Column(
                        children: [
                          _buildIncidentItem(incident),
                          if (!isLast)
                            Divider(
                              color: Colors.grey[200],
                              height: 32,
                              thickness: 1,
                            ),
                        ],
                      );
                    }).toList(),
                  )
                : Container(
                    padding: const EdgeInsets.all(20),
                    child: const Center(
                      child: Text(
                        'Aucun incident enregistré',
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildIncidentItem(Incident incident) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Icône d'alerte (triangle orange comme dans l'image)
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: incident.type.color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(incident.type.icon, color: incident.type.color, size: 16),
        ),

        const SizedBox(width: 12),

        // Contenu de l'incident
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Titre de l'incident
              Text(
                incident.titre,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 6),

              // Date et heure avec icône
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 12, color: Colors.grey[500]),
                  const SizedBox(width: 4),
                  Text(
                    _formatDateTime(incident.dateHeure),
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),

              const SizedBox(height: 2),

              // Durée avec icône
              Row(
                children: [
                  Icon(Icons.access_time, size: 12, color: Colors.grey[500]),
                  const SizedBox(width: 4),
                  Text(
                    'Durée: ${_formatDuration(incident.duree)}',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),

              const SizedBox(height: 2),

              // Action avec icône
              Row(
                children: [
                  Icon(Icons.build, size: 12, color: Colors.grey[500]),
                  const SizedBox(width: 4),
                  Text(
                    'Action: ${incident.action}',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Badge de statut (exactement comme l'image)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: incident.status.color,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            incident.status.label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    ),
  );
}

String _formatDateTime(DateTime dateTime) {
  return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
}

String _formatDuration(Duration duration) {
  if (duration.inMinutes > 0) {
    return '${duration.inMinutes} min';
  } else {
    return '${duration.inSeconds} sec';
  }
}
