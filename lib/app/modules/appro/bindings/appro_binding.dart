import 'package:get/get.dart';

import '../controllers/appro_controller.dart';

class ApproBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApproController>(
      () => ApproController(),
    );
  }
}
