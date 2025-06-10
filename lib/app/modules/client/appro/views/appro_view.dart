import 'package:flutter/material.dart';
import 'package:gaz_connect/app/modules/client/appro/livraison/get_livraison_widget.dart';
import 'package:gaz_connect/app/modules/client/appro/livraison/livraison_controller.dart';
import 'package:gaz_connect/app/views/views/client_view.dart';

import 'package:get/get.dart';

import '../controllers/appro_controller.dart';

class ApproView extends GetView<ApproController> {
  const ApproView({super.key});
  @override
  Widget build(BuildContext context) {
    final LivraisonController controller = Get.put(LivraisonController());
    final body = SingleChildScrollView(
      child: Column(
        children: [SizedBox(height: 20), getLivraisonWidget(controller)],
      ),
    );
    return ClientView(body: body);
  }
}
