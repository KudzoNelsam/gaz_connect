import 'package:gaz_connect/app/modules/securite/contacts/emergency_contact.dart';
import 'package:get/get.dart';

class EmergencyContactsController extends GetxController {
  var contacts = <EmergencyContact>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Contacts par défaut comme dans l'image
    contacts.value = [
      EmergencyContact(id: '1', nom: 'Papa', telephone: '+221 77 XXX XX XX'),
      EmergencyContact(
        id: '2',
        nom: 'Service Technique',
        telephone: '+221 33 XXX XX XX',
      ),
      EmergencyContact(
        id: '3',
        nom: 'Voisin Ahmed',
        telephone: '+221 76 XXX XX XX',
      ),
    ];
  }

  void updateContacts(List<EmergencyContact> newContacts) {
    contacts.value = newContacts;
    print('[${DateTime.now()}] nelsam12 a mis à jour les contacts');
  }
}
