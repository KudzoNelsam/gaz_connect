import 'package:flutter/material.dart';
import 'package:gaz_connect/app/views/views/client_view.dart';

import 'package:get/get.dart';

import '../controllers/settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});
  @override
  Widget build(BuildContext context) {
    return ClientView(body: const Center(child: Text('Page paramètre')));
  }
}
