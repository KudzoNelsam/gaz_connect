import 'package:flutter/material.dart';
import 'package:gaz_connect/app/modules/settings/notification/notification_controller.dart';
import 'package:get/get.dart';

Widget getNotificationsWidget(NotificationSettingsController controller) {
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
              Icon(Icons.notifications, color: Colors.blue, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Notifications',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Contenu des notifications
          Obx(
            () => controller.isLoading.value
                ? _buildLoadingState()
                : _buildNotificationsContent(controller),
          ),
        ],
      ),
    ),
  );
}

Widget _buildLoadingState() {
  return const SizedBox(
    height: 150,
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 12),
          Text(
            'Chargement des paramètres...',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
    ),
  );
}

Widget _buildNotificationsContent(NotificationSettingsController controller) {
  return Column(
    children: [
      // ✅ Notifications push (exactement comme l'image)
      _buildNotificationSwitch(
        title: 'Notifications push',
        subtitle: 'Alertes dans l\'application',
        value: controller.notificationsPushActivees,
        onChanged: (value) => controller.toggleNotificationsPush(value),
      ),

      const SizedBox(height: 20),

      // ✅ Alertes SMS (exactement comme l'image)
      _buildNotificationSwitch(
        title: 'Alertes SMS',
        subtitle: 'Messages texte d\'urgence',
        value: controller.alertesSMSActivees,
        onChanged: (value) => controller.toggleAlertesSMS(value),
      ),

      const SizedBox(height: 24),

      // ✅ Seuil d'alerte (exactement comme l'image)
      _buildSeuilAlerte(controller),
    ],
  );
}

Widget _buildNotificationSwitch({
  required String title,
  required String subtitle,
  required bool value,
  required Function(bool) onChanged,
}) {
  return Row(
    children: [
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
            ),
          ],
        ),
      ),

      // ✅ Switch bleu (exactement comme l'image)
      Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Colors.blue,
        activeTrackColor: Colors.blue.withOpacity(0.3),
        inactiveThumbColor: Colors.grey[400],
        inactiveTrackColor: Colors.grey[300],
      ),
    ],
  );
}

Widget _buildSeuilAlerte(NotificationSettingsController controller) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Label du seuil
      const Text(
        'Seuil d\'alerte (%)',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),

      const SizedBox(height: 12),

      // ✅ Dropdown du seuil (exactement comme l'image)
      Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[400]!, width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Obx(
          () => DropdownButtonHideUnderline(
            child: DropdownButton<double>(
              value: controller.seuilAlerteGlobal,
              isExpanded: true,
              items: controller.getSeuilsPredefinis().map((seuil) {
                return DropdownMenuItem<double>(
                  value: seuil,
                  child: Row(
                    children: [
                      Text(
                        '${seuil.toStringAsFixed(0)}%', // ✅ Format comme dans l'image
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      const Spacer(),
                      if (seuil == controller.seuilAlerteGlobal)
                        Icon(Icons.check, color: Colors.blue, size: 16),
                    ],
                  ),
                );
              }).toList(),
              onChanged: controller.isSaving.value
                  ? null
                  : (value) {
                      if (value != null) {
                        print(
                          '[2025-06-09 13:56:59] nelsam12 - Nouveau seuil sélectionné: ${value.toStringAsFixed(0)}%',
                        );
                        controller.modifierSeuilAlerte(value);
                      }
                    },
              icon: controller.isSaving.value
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
            ),
          ),
        ),
      ),

      const SizedBox(height: 12),

      // Description du seuil
      Obx(
        () => Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.blue[200]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.info, color: Colors.blue[700], size: 16),
                  const SizedBox(width: 6),
                  Text(
                    'Seuil actuel: ${controller.seuilAlerteFormateGlobal}',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.blue[700],
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                controller.getDescriptionSeuil(),
                style: TextStyle(fontSize: 12, color: Colors.blue[600]),
              ),
              const SizedBox(height: 4),
              Text(
                'Modifié par: nelsam12',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}
