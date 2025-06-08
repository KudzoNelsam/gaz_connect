import 'package:flutter/material.dart';
import 'package:gaz_connect/app/views/views/client_view.dart';

import 'package:get/get.dart';

import '../controllers/securite_controller.dart';

class SecuriteView extends GetView<SecuriteController> {
  const SecuriteView({super.key});
  @override
  Widget build(BuildContext context) {
    return ClientView(body: const Center(child: Text('Page sécurité')));
  }
}
