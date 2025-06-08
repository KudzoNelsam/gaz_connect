import 'package:get/get.dart';

import '../controllers/securite_controller.dart';

class SecuriteBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SecuriteController>(
      () => SecuriteController(),
    );
  }
}
