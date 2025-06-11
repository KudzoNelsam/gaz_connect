import 'package:flutter/material.dart';
import 'package:gaz_connect/app/core/network/impl/tech_service_impl.dart';
import 'package:gaz_connect/app/core/network/tech_service.dart';
import 'package:gaz_connect/app/routes/app_pages.dart';
import 'package:get/get.dart';

import '../../../models/installation_response.dart';
import 'installation_card.dart';

class ClientManagementScreen extends StatefulWidget {
  const ClientManagementScreen({super.key});

  @override
  _ClientManagementScreenState createState() => _ClientManagementScreenState();
}

class _ClientManagementScreenState extends State<ClientManagementScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TechService techService = Get.find<TechServiceImpl>();

  List<InstallationResponse> installations = [];
  List<InstallationResponse> _filteredInstallations = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadInstallations(); // Appel sans await
    _searchController.addListener(_filterInstallations);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterInstallations);
    _searchController.dispose();
    super.dispose();
  }

  // Méthode séparée pour charger les données
  Future<void> _loadInstallations() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      // Test avec getInstallations() pour voir la structure
      final restResponse = await techService.getInstallations();
      print('RestResponse: $restResponse');
      print('Type: ${restResponse.type}');
      print('Status: ${restResponse.status}');
      print('Results: ${restResponse.results}');

      // Puis essayer avec getInstallationsToday()
      final loadedInstallations = await techService.getInstallationsToday();

      setState(() {
        installations = loadedInstallations;
        _filteredInstallations = loadedInstallations;
        isLoading = false;
      });
    } catch (e) {
      print('Erreur lors du chargement: $e');
      setState(() {
        isLoading = false;
        errorMessage = 'Erreur lors du chargement des installations';
        // En cas d'erreur, utiliser les données mock
        installations = _getMockData();
        _filteredInstallations = installations;
      });
    }
  }

  // Données mock de fallback
  List<InstallationResponse> _getMockData() {
    return [

    ];
  }

  void _filterInstallations() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredInstallations = installations.where((installation) {
        return installation.nomComplet.toLowerCase().contains(query) ||
            installation.clientId.toString().contains(query) ||
            installation.adresse.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: RefreshIndicator(
        onRefresh: _loadInstallations,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Barre de recherche
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Rechercher par nom ou ID client...',
                    hintStyle: TextStyle(color: Colors.grey[500]),
                    prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                      icon: Icon(Icons.clear, color: Colors.grey[500]),
                      onPressed: () {
                        _searchController.clear();
                      },
                    )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 12.0,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20.0),

              // Boutons d'action
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Get.toNamed(Routes.TECHNICIEN_INTERVENTIONS);
                      },
                      icon: const Icon(Icons.assignment, color: Colors.white),
                      label: const Text(
                        'Mes interventions',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[700],
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12.0),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        _showLogoutDialog();
                      },
                      icon: const Icon(Icons.logout, color: Colors.red),
                      label: const Text(
                        'Déconnexion',
                        style: TextStyle(color: Colors.red),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.red),
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24.0),

              // Titre "Mes clients" avec bouton refresh
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Mes Installations',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue,
                    ),
                  ),
                  if (!isLoading)
                    IconButton(
                      onPressed: _loadInstallations,
                      icon: const Icon(Icons.refresh, color: Colors.blue),
                    ),
                ],
              ),

              const SizedBox(height: 16.0),

              // Contenu principal
              Expanded(
                child: _buildContent(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.warning_amber_outlined,
              size: 64,
              color: Colors.orange[400],
            ),
            const SizedBox(height: 16),
            Text(
              errorMessage!,
              style: const TextStyle(
                fontSize: 16.0,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Données mock utilisées',
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.orange,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadInstallations,
              child: const Text('Réessayer'),
            ),
          ],
        ),
      );
    }

    if (_filteredInstallations.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'Aucun client trouvé',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: _filteredInstallations.length,
      itemBuilder: (context, index) {
        return InstallationCard(
          installation: _filteredInstallations[index],
        );
      },
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Déconnexion'),
          content: const Text('Êtes-vous sûr de vouloir vous déconnecter ?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Get.offAllNamed('/login');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Déconnexion'),
            ),
          ],
        );
      },
    );
  }
}