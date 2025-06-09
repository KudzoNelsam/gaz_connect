import 'package:flutter/material.dart';
import 'package:gaz_connect/app/modules/securite/contacts/emergency_contact.dart';
import 'package:gaz_connect/app/modules/securite/contacts/emergency_contacts_controller.dart';
import 'package:get/get.dart';

Widget getContacts(EmergencyContactsController controller) {
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
              Icon(Icons.phone, color: Colors.blue, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Contacts d\'Urgence',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Liste des contacts (exactement comme l'image)
          Obx(
            () => Column(
              children: controller.contacts.asMap().entries.map((entry) {
                int index = entry.key;
                EmergencyContact contact = entry.value;
                bool isLast = index == controller.contacts.length - 1;

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          // Contenu du contact
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  contact.nom,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  contact.telephone,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Numéro de priorité (exactement comme l'image)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '#${index + 1}',
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Ligne de séparation (sauf pour le dernier)
                    if (!isLast)
                      Divider(
                        color: Colors.grey[200],
                        height: 24,
                        thickness: 1,
                      ),
                  ],
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 24),

          // Bouton "Modifier les contacts" (exactement comme l'image)
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                print(
                  '[2025-06-09 09:22:36] nelsam12 clique sur Modifier les contacts',
                );
                _handleModifyContacts();
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: BorderSide(color: Colors.grey[300]!),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Modifier les contacts',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

void _handleModifyContacts() {
  // Ici vous pouvez ajouter la logique pour modifier les contacts
  Get.snackbar(
    'Action',
    'Fonctionnalité de modification en cours de développement - nelsam12',
    snackPosition: SnackPosition.BOTTOM,
  );
}
