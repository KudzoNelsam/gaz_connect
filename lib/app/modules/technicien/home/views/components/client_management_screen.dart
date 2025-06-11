import 'package:flutter/material.dart';

import '../models/client_model.dart';

class ClientManagementScreen extends StatefulWidget {
  const ClientManagementScreen({super.key});

  @override
  _ClientManagementScreenState createState() => _ClientManagementScreenState();
}

class _ClientManagementScreenState extends State<ClientManagementScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<Client> clients = [
    Client(
      id: 1,
      name: 'Jean Dupont',
      address: '123 Rue de la Paix, Paris',
      capteurs: 2,
      bouteilles: 3,
      status: ClientStatus.actif,
    ),
    Client(
      id: 2,
      name: 'Marie Martin',
      address: '456 Avenue des Champs, Lyon',
      capteurs: 0,
      bouteilles: 0,
      status: ClientStatus.aInstaller,
    ),
    Client(
      id: 3,
      name: 'Pierre Durand',
      address: '789 Boulevard Central, Marseille',
      capteurs: 3,
      bouteilles: 4,
      status: ClientStatus.aVerifier,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Padding(
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
                      // Action pour "Mes interventions"
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
                      // Action pour déconnexion
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

            // Titre "Mes clients"
            const Text(
              'Mes clients',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w600,
                color: Colors.blue,
              ),
            ),

            const SizedBox(height: 16.0),

            // Liste des clients
            Expanded(
              child: ListView.builder(
                itemCount: clients.length,
                itemBuilder: (context, index) {
                  return ClientCard(client: clients[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}