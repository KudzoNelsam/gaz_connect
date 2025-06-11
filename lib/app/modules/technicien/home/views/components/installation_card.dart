// widgets/installation_card.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../../models/installation_response.dart';
import '../../../views_other/client_details_view.dart';

class InstallationCard extends StatelessWidget {
  final InstallationResponse installation;

  const InstallationCard({super.key, required this.installation});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Navigation avec clé unique
        Get.to(
              () => ClientDetailsView(
            key: Key('client_details_${installation.clientId}_${DateTime.now().millisecondsSinceEpoch}'),
            installationId: installation.id,
            clientId: installation.clientId,
            clientName: installation.nomComplet,
            nbrCapteursCommandes: installation.nbrCapteur,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          border: Border(
            left: BorderSide(
              color: installation.statut.statutBorderColor,
              width: 4.0,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        installation.nomComplet,
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(height: 2.0),
                      Text(
                        'Téléphone: ${installation.telephone}',
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                _buildStatusChip(installation.statut),
              ],
            ),
            const SizedBox(height: 8.0),
            Text(
              installation.adresse,
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 12.0),
            Row(
              children: [
                Text(
                  '${installation.nbrCapteur} capteurs',
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                // Text(
                //   '${installation.nbrBouteilles} bouteilles',
                //   style: const TextStyle(
                //     fontSize: 14.0,
                //     color: Colors.orange,
                //     fontWeight: FontWeight.w600,
                //   ),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String statut) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: statut.statutBackgroundColor,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Text(
        statut.statutLabel,
        style: TextStyle(
          fontSize: 12.0,
          fontWeight: FontWeight.w500,
          color: statut.statutColor,
        ),
      ),
    );
  }
}