import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 🎯 Logo
            _buildLogo(),

            const SizedBox(height: 60),

            // 📝 Formulaire
            _buildForm(),

            const SizedBox(height: 24),

            // 🚀 Bouton
            _buildButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: const BoxDecoration(
            color: Color(0xFF2196F3),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.local_fire_department,
            color: Colors.white,
            size: 30,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'GazConnect',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  // Dans la vue, modifiez _buildForm()
  Widget _buildForm() {
    return Form(
      // ✅ Wrap avec Form
      key: controller.formKey,
      child: Column(
        children: [
          // Email
          TextFormField(
            // ✅ TextFormField au lieu de TextField
            controller: controller.emailController,
            decoration: const InputDecoration(
              hintText: 'Email',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              // ✅ Validation
              if (value == null || value.trim().isEmpty) {
                return 'L\'email est requis';
              }
              return null;
            },
          ),

          const SizedBox(height: 16),

          // Password
          Obx(
            () => TextFormField(
              // ✅ TextFormField au lieu de TextField
              controller: controller.passwordController,
              obscureText: controller.isPasswordHidden.value,
              decoration: InputDecoration(
                hintText: 'Mot de passe',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    controller.isPasswordHidden.value
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                  onPressed: controller.togglePasswordVisibility,
                ),
              ),
              validator: (value) {
                // ✅ Validation
                if (value == null || value.trim().isEmpty) {
                  return 'Le mot de passe est requis';
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton() {
    return Obx(
      () => Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          color: controller.isLoading.value
              ? Colors.grey
              : const Color(0xFF2196F3),
          borderRadius: BorderRadius.circular(8), // ✅ Bordures arrondies
        ),
        child: ElevatedButton(
          onPressed: controller.isLoading.value ? null : controller.seConnecter,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: controller.isLoading.value
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text('Connexion', style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}
