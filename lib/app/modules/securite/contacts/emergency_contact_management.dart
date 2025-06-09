import 'package:flutter/material.dart';
import 'package:gaz_connect/app/modules/securite/contacts/emergency_contact.dart';

class EmergencyContactsManagementPage extends StatelessWidget {
  final List<EmergencyContact> contacts;
  final Function(List<EmergencyContact>)? onContactsChanged;

  const EmergencyContactsManagementPage({
    super.key,
    required this.contacts,
    this.onContactsChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gérer les Contacts'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              // Ajouter un nouveau contact
              _ajouterContact(context);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: contacts.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.contacts, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Aucun contact configuré',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            )
          : ReorderableListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: contacts.length,
              onReorder: (oldIndex, newIndex) {
                if (newIndex > oldIndex) newIndex--;
                final contact = contacts.removeAt(oldIndex);
                contacts.insert(newIndex, contact);
                if (onContactsChanged != null) {
                  onContactsChanged!(contacts);
                }
              },
              itemBuilder: (context, index) {
                final contact = contacts[index];
                return Card(
                  key: Key(contact.id),
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: Text(
                        '#${index + 1}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(contact.nom),
                    subtitle: Text(contact.telephone),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () =>
                              _modifierContact(context, contact, index),
                          icon: const Icon(Icons.edit),
                        ),
                        IconButton(
                          onPressed: () => _supprimerContact(context, index),
                          icon: const Icon(Icons.delete, color: Colors.red),
                        ),
                        const Icon(Icons.drag_handle),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _ajouterContact(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _ajouterContact(BuildContext context) {
    // Logique pour ajouter un contact
    // Similar to the dialog in the main widget
  }

  void _modifierContact(
    BuildContext context,
    EmergencyContact contact,
    int index,
  ) {
    // Logique pour modifier un contact
  }

  void _supprimerContact(BuildContext context, int index) {
    // Logique pour supprimer un contact
  }
}
