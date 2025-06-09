import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SystemTestController extends GetxController {
  var isTestInProgress = false.obs;
  var lastTestDate = Rx<DateTime?>(null);
  var testResult = ''.obs;

  bool get canTest => !isTestInProgress.value;
  String get lastTestFormatted {
    if (lastTestDate.value == null) return 'Aucun test effectué';
    final date = lastTestDate.value!;
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  void startSystemTest() {
    if (isTestInProgress.value) return;

    isTestInProgress.value = true;
    testResult.value = '';

    print('[2025-06-09 09:26:52] nelsam12 démarre le test du système');

    // Simulation du test
    Future.delayed(const Duration(seconds: 3), () {
      isTestInProgress.value = false;
      lastTestDate.value = DateTime.now();
      testResult.value = 'Test réussi';

      Get.snackbar(
        'Test du système',
        'Test terminé avec succès - nelsam12',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      print(
        '[2025-06-09 09:26:55] nelsam12 - Test système terminé: ${testResult.value}',
      );
    });
  }
}
