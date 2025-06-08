import 'package:flutter/material.dart';
import 'package:gaz_connect/app/routes/app_pages.dart';
import 'package:gaz_connect/app/views/views/main_layout_view.dart';

import 'package:get/get.dart';

import '../controllers/securite_controller.dart';

class SecuriteView extends GetView<SecuriteController> {
  const SecuriteView({super.key});
  @override
  Widget build(BuildContext context) {
    return MainLayoutView(
      title: 'Sécurité',
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Accueil'),
        BottomNavigationBarItem(icon: Icon(Icons.shield), label: 'Securité'),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Paramètres',
        ),
      ],
      itemLabels: [Routes.HOME, Routes.SECURITE, Routes.SETTINGS],
      body: const Center(child: Text('Page d\'accueil')),
    );
  }
}
