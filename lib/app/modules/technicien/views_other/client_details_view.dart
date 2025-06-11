// views/client_details_view.dart
import 'package:flutter/material.dart';
import 'package:gaz_connect/app/core/network/impl/tech_service_impl.dart';
import 'package:gaz_connect/app/core/network/tech_service.dart';
import 'package:get/get.dart';

import '../models/client_details_dto_page.dart';
import 'ajouter_bouteille_view.dart';

class ClientDetailsView extends StatefulWidget {
  final int clientId;
  final String clientName;
  final int nbrCapteursCommandes; // Nombre de capteurs commandés
  final int installationId; // Nouveau paramètre

  const ClientDetailsView({
    super.key,
    required this.clientId,
    required this.clientName,
    required this.nbrCapteursCommandes,
    required this.installationId
  });

  @override
  _ClientDetailsViewState createState() => _ClientDetailsViewState();
}

class _ClientDetailsViewState extends State<ClientDetailsView> {
  final TechService techService = Get.find<TechServiceImpl>();

  ClientDetailsDtoPage? clientDetails;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadClientDetails();
  }

  // Calculer le nombre de capteurs installés
  int get nbrCapteursInstalles {
    if (clientDetails == null) return 0;
    return clientDetails!.bouteilles
        .where((bouteille) => bouteille.capteurId != null)
        .length;
  }

  // Vérifier si l'intervention peut être terminée
  bool get peutTerminerIntervention {
    return nbrCapteursInstalles >= widget.nbrCapteursCommandes;
  }

  Future<void> _loadClientDetails() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      final details = await techService.getClientDetails(widget.clientId);

      setState(() {
        clientDetails = details;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Erreur lors du chargement des détails';
      });
      print('Erreur: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1976D2),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.clientName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Text(
              'Détails du client',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        titleSpacing: 0,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red[400]),
            const SizedBox(height: 16),
            Text(errorMessage!, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadClientDetails,
              child: const Text('Réessayer'),
            ),
          ],
        ),
      );
    }

    if (clientDetails == null) {
      return const Center(child: Text('Aucune donnée disponible'));
    }

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildClientInfoCard(),
                const SizedBox(height: 16),
                _buildActionButton(),
                const SizedBox(height: 24),
                _buildBouteillesSection(),
                const SizedBox(height: 16),
                _buildInstallationStatus(), // Nouveau widget pour le statut
              ],
            ),
          ),
        ),
        _buildBottomButton(),
      ],
    );
  }

  Widget _buildClientInfoCard() {
    final client = clientDetails!.client;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
        border: const Border(
          left: BorderSide(color: Color(0xFF1976D2), width: 4),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(Icons.phone_outlined, color: Color(0xFF1976D2), size: 20),
                const SizedBox(width: 8),
                Text(
                  client.telephone,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'Actif',
                    style: TextStyle(
                      color: Color(0xFF10B981),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.location_on_outlined, color: Color(0xFF1976D2), size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    client.adresse,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => _ajouterBouteille(),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Ajouter bouteille'),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1976D2),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  Widget _buildBouteillesSection() {
    final bouteilles = clientDetails!.bouteilles;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.propane_tank, color: Color(0xFF1976D2), size: 24),
            const SizedBox(width: 8),
            Text(
              'Bouteilles installées (${bouteilles.length})',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1976D2),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (bouteilles.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Column(
              children: [
                Icon(
                  Icons.propane_tank_outlined,
                  size: 48,
                  color: Color(0xFF9CA3AF),
                ),
                SizedBox(height: 16),
                Text(
                  'Aucune bouteille installée',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF6B7280),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Ajoutez une bouteille pour commencer',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF9CA3AF),
                  ),
                ),
              ],
            ),
          )
        else
          ...bouteilles.map((bouteille) => _buildBouteilleCard(bouteille)),
      ],
    );
  }

  // Nouveau widget pour afficher le statut de l'installation
  Widget _buildInstallationStatus() {
    final statusColor = peutTerminerIntervention
        ? const Color(0xFF10B981)
        : const Color(0xFFF59E0B);
    final statusBgColor = statusColor.withOpacity(0.1);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border(
          left: BorderSide(color: statusColor, width: 4),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.sensors,
                color: statusColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                'État de l\'installation',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusBgColor,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  peutTerminerIntervention ? 'Complète' : 'En cours',
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Capteurs installés : $nbrCapteursInstalles / ${widget.nbrCapteursCommandes}',
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF6B7280),
            ),
          ),
          if (!peutTerminerIntervention) ...[
            const SizedBox(height: 8),
            Text(
              'Vous devez installer ${widget.nbrCapteursCommandes - nbrCapteursInstalles} capteur(s) supplémentaire(s) pour terminer l\'intervention.',
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFFF59E0B),
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBouteilleCard(BouteilleResponseDto bouteille) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bouteille.nom,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      bouteille.poidsFormatted,
                      style: const TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${bouteille.pourcentageRestant}%',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: bouteille.statusColor,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: bouteille.statusBackgroundColor,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        bouteille.statusLabel,
                        style: TextStyle(
                          color: bouteille.statusColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              height: 6,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(3),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: bouteille.pourcentageRestant / 100,
                child: Container(
                  decoration: BoxDecoration(
                    color: bouteille.statusColor,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ),
            if (bouteille.capteurId != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.sensors,
                    size: 16,
                    color: const Color(0xFF10B981),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Capteur: ${bouteille.capteurId}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF10B981),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ] else ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.sensors_off,
                    size: 16,
                    color: Colors.orange[600],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Non assignée à un capteur',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.orange[600],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBottomButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: peutTerminerIntervention ? _terminerIntervention : null,
            icon: Icon(
              Icons.check,
              color: peutTerminerIntervention ? Colors.white : Colors.grey,
            ),
            label: Text(
              peutTerminerIntervention
                  ? 'Terminer l\'intervention'
                  : 'Installation incomplète (${widget.nbrCapteursCommandes - nbrCapteursInstalles} capteur(s) manquant(s))',
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: peutTerminerIntervention
                  ? const Color(0xFF10B981)
                  : Colors.grey[300],
              foregroundColor: peutTerminerIntervention
                  ? Colors.white
                  : Colors.grey[600],
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ),
      ),
    );
  }

  // Modifier la méthode _ajouterBouteille dans ClientDetailsView
  void _ajouterBouteille() async {
    final result = await Get.to(() => AjouterBouteilleView(
      clientId: widget.clientId,
      typesBouteille: clientDetails!.typesBouteille,
    ));

    // Si une bouteille a été ajoutée, recharger les données
    if (result == true) {
      _loadClientDetails();
    }
  }

  // Aussi modifier _terminerIntervention pour utiliser l'API
  void _terminerIntervention() async {
    Get.dialog(
      AlertDialog(
        title: const Text('Terminer l\'intervention'),
        content: Text(
            'Tous les capteurs ont été installés ($nbrCapteursInstalles/${widget.nbrCapteursCommandes}). '
                'Êtes-vous sûr de vouloir terminer cette intervention ?'
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () async {
              Get.back(); // Fermer le dialog

              // Appeler l'API pour terminer l'installation
              final success = await techService.terminerInstallation(widget.installationId); // Vous devez passer l'installationId

              if (success) {
                Get.until((route) => route.isFirst); // Retourner à la page principale
                Get.snackbar(
                  'Succès',
                  'Intervention terminée avec succès',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: const Color(0xFF10B981),
                  colorText: Colors.white,
                );
              } else {
                Get.snackbar(
                  'Erreur',
                  'Impossible de terminer l\'intervention',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF10B981),
              foregroundColor: Colors.white,
            ),
            child: const Text('Terminer'),
          ),
        ],
      ),
    );
  }


  }