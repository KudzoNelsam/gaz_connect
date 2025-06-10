import 'package:get/get.dart';

import '../controllers/conso_controller.dart';

class ConsoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ConsoController>(
      () => ConsoController(),
    );
  }
}
