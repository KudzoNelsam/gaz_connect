import 'package:flutter/material.dart';
import 'package:gaz_connect/app/routes/app_pages.dart';
import 'package:gaz_connect/app/views/views/main_layout_view.dart';

import 'package:get/get.dart';

class ClientView extends GetView {
  final Widget body;
  const ClientView({required this.body, super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayoutView(
      title: "GazConnect",
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Accueil'),
        BottomNavigationBarItem(icon: Icon(Icons.shield), label: 'Securité'),
        BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Conso'),
        BottomNavigationBarItem(
          icon: Icon(Icons.delivery_dining),
          label: 'Appro',
        ),

        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Paramètres',
        ),
      ],
      itemLabels: [
        Routes.CLIENT_HOME,
        Routes.SECURITE,
        Routes.CONSO,
        Routes.APPRO,
        Routes.SETTINGS,
      ],
      body: body,
    );
    // return Text("data");
  }
}
