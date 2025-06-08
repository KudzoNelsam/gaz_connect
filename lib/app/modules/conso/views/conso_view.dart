import 'package:flutter/material.dart';
import 'package:gaz_connect/app/views/views/client_view.dart';

import 'package:get/get.dart';

import '../controllers/conso_controller.dart';

class ConsoView extends GetView<ConsoController> {
  const ConsoView({super.key});
  @override
  Widget build(BuildContext context) {
    return ClientView(body: const Center(child: Text('Page de consommation')));
  }
}
