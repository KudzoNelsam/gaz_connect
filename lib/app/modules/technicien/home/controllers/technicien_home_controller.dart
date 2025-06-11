import 'package:gaz_connect/app/core/network/impl/tech_service_impl.dart';
import 'package:gaz_connect/app/core/network/tech_service.dart';
import 'package:get/get.dart';

class TechnicienController extends GetxController {
  final TechService techService = Get.find<TechServiceImpl>();
}