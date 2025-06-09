import 'package:flutter/material.dart';
import 'package:gaz_connect/app/views/views/client_view.dart';

import 'package:get/get.dart';

import '../controllers/appro_controller.dart';

class ApproView extends GetView<ApproController> {
  const ApproView({super.key});
  @override
  Widget build(BuildContext context) {
    final body = SingleChildScrollView(
      child: Column(
        children: [
          //  ✅ Nouveau widget
        ],
      ),
    );
    return ClientView(body: body);
  }
}
