import 'package:gaz_connect/app/core/login/rest_response.dart';
import 'package:gaz_connect/app/core/network/impl/auth_service_auth_impl.dart';
import 'package:gaz_connect/app/core/network/role.dart';
import 'package:gaz_connect/app/core/network/user_connected.dart';
import 'package:gaz_connect/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class LoginController extends GetxController {
  final authService = Get.find<AuthServiceImpl>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final isLoading = false.obs;
  final isPasswordHidden = true.obs;
  final formKey = GlobalKey<FormState>(); // ✅ Clé pour validation

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  Future<void> seConnecter() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    isLoading.value = true;
    final success = await authService.login(
      emailController.text.trim(),
      passwordController.text.trim(),
    );

    isLoading.value = false;

    if (success) {
      final RestResponse response = await authService.getUserConnected();
      if (response.status == 200) {
        UserConnected userConnected = authService.getUser()!;

        // print(userConnected.role);
        switch (userConnected.role) {
          case Role.ADMIN:
            Get.snackbar(
              'Erreur de connexion',
              'Veuillez réessayer',
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
            authService.logout();

            break;
          case Role.CLIENT:
            Get.snackbar(
              'Connexion réussie',
              'Bienvenue',
              backgroundColor: Colors.green,
              colorText: Colors.white,
            );
            Get.offAllNamed(Routes.CLIENT_HOME);
            break;
          case Role.TECHNICIEN:
            Get.snackbar(
              'Connexion réussie',
              'Bienvenue',
              backgroundColor: Colors.green,
              colorText: Colors.white,
            );
            Get.offAllNamed(Routes.TECHNICIEN_HOME);
            break;
        }
      }
    } else {
      Get.snackbar(
        'Erreur de connexion',
        'Veuillez réessayer',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void redirectToPage(String role) {
    if (role.toUpperCase() == "CLIENT") {
      // print("redirection client");
      Get.toNamed(Routes.CLIENT_HOME);
    } else if (role.toUpperCase() == "TECHNICIAN") {
      print("redirection techno");

      Get.offAllNamed(Routes.TECHNICIEN_HOME);
    } else {
      print("redirection error");

      Get.offAllNamed(Routes.ERROR_PAGE);
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
