import 'package:get/get.dart';

import '../controllers/technicien_home_controller.dart';

class TechnicienHomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TechnicienController>(() => TechnicienController());
  }
}
