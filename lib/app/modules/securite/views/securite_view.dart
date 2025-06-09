import 'package:flutter/material.dart';
import 'package:gaz_connect/app/modules/securite/contacts/contact_function.dart';
import 'package:gaz_connect/app/modules/securite/contacts/emergency_contacts_controller.dart';
import 'package:gaz_connect/app/modules/securite/security_settings/security_settings_card.dart';
import 'package:gaz_connect/app/modules/securite/security_settings/securiy_settings_controller.dart';
import 'package:gaz_connect/app/modules/securite/system/get_system_test.dart';
import 'package:gaz_connect/app/modules/securite/system/system_test_controller.dart';
import 'package:gaz_connect/app/views/views/client_view.dart';
import 'package:gaz_connect/app/views/views/statut_card_view.dart';

import 'package:get/get.dart';

import '../controllers/securite_controller.dart';

class SecuriteView extends GetView<SecuriteController> {
  const SecuriteView({super.key});
  @override
  Widget build(BuildContext context) {
    final SecuritySettingsController controller = Get.put(
      SecuritySettingsController(),
    );
    final EmergencyContactsController contactController = Get.put(
      EmergencyContactsController(),
    );

    final SystemTestController systemTestController = Get.put(
      SystemTestController(),
    );

    final body = SingleChildScrollView(
      child: Column(
        children: [
          getStatutCard(),
          getOptions(controller),
          getContacts(contactController),
          getSystemTest(systemTestController),
        ],
      ),
    );
    return ClientView(body: body);
  }

  Widget getStatutCard() {
    return StatusCard(
      titre: 'Statut Sécurité',
      sousTitre: 'Système actif',
      type: StatusType.securite,
      etat: StatusState.protege,
      // ignore: avoid_print
      onTap: () => print('Sécurité tapped'),
    );
  }

  Widget getOptions(
    SecuritySettingsController controller, {
    bool showDebugInfo = true,
    Color? accentColor,
    EdgeInsets? margin,
    Function(String, bool)? onOptionChanged,
  }) {
    // Définir les options de sécurité
    List<SecurityOption> securityOptions = [
      SecurityOption(
        titre: 'Coupure automatique',
        description: 'En cas de fuite détectée',
        isEnabled: controller.coupureAutomatique.value,
        icone: Icons.power_settings_new,
        onChanged: () {
          print('Coupure automatique: ${controller.coupureActive}');
          if (onOptionChanged != null) {
            onOptionChanged('coupure', controller.coupureActive);
          }
        },
      ),
      SecurityOption(
        titre: 'Alertes de fuite',
        description: 'Notifications push instantanées',
        isEnabled: controller.alertesFuite.value,
        icone: Icons.notification_important,
        onChanged: () {
          print('Alertes de fuite: ${controller.alertesActives}');
          if (onOptionChanged != null) {
            onOptionChanged('alertes', controller.alertesActives);
          }
        },
      ),
      SecurityOption(
        titre: 'Appels d\'urgence',
        description: 'Contacts automatiques',
        isEnabled: controller.appelsUrgence.value,
        icone: Icons.phone,
        onChanged: () {
          print('Appels d\'urgence: ${controller.urgenceActive}');
          if (onOptionChanged != null) {
            onOptionChanged('urgence', controller.urgenceActive);
          }
        },
      ),
    ];

    return Column(
      children: [
        // Widget principal des paramètres
        SecuritySettingsCard(
          options: securityOptions,
          onSettingsChanged: (settings) {
            controller.updateSettings(settings);
          },
          couleurAccent: accentColor ?? Colors.blue,
          margin: margin,
        ),
      ],
    );
  }
}
