import 'package:flutter/material.dart';
import 'package:gaz_connect/app/modules/securite/system/system_test_controller.dart';
import 'package:get/get.dart';

Widget getSystemTest(SystemTestController controller) {
  return Container(
    margin: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: const Color(0xFFF0F8FF), // Bleu très clair comme dans l'image
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: const Color(0xFFB8D4F0), // Bordure bleu clair
        width: 1,
      ),
    ),
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Titre principal
          const Text(
            'Test du système',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1565C0), // Bleu foncé
            ),
          ),

          const SizedBox(height: 8),

          // Description
          Text(
            'Vérification mensuelle recommandée',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 20),

          // Bouton de test
          Obx(
            () => SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: controller.canTest
                    ? () {
                        controller.startSystemTest();
                      }
                    : null,
                icon: controller.isTestInProgress.value
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : const Icon(Icons.notifications, size: 18),
                label: Text(
                  controller.isTestInProgress.value
                      ? 'Test en cours...'
                      : 'Tester maintenant',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(
                    0xFF1976D2,
                  ), // Bleu comme dans l'image
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
              ),
            ),
          ),

          // Informations du dernier test
          const SizedBox(height: 16),
          Obx(
            () => Column(
              children: [
                if (controller.lastTestDate.value != null) ...[
                  Divider(color: Colors.grey[300]),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Dernier test:',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                      Text(
                        controller.lastTestFormatted,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  if (controller.testResult.value.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Résultat:',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              size: 14,
                              color: Colors.green,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              controller.testResult.value,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ],
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
