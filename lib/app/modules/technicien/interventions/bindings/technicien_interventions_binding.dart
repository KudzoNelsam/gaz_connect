import 'package:get/get.dart';

import '../controllers/technicien_interventions_controller.dart';

class TechnicienInterventionsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TechnicienInterventionsController>(
      () => TechnicienInterventionsController(),
    );
  }
}
