import 'package:get/get.dart';

import '../modules/client/appro/bindings/appro_binding.dart';
import '../modules/client/appro/views/appro_view.dart';
import '../modules/client/conso/bindings/conso_binding.dart';
import '../modules/client/conso/views/conso_view.dart';
import '../modules/client/home/bindings/home_binding.dart';
import '../modules/client/home/views/home_view.dart';
import '../modules/error_page/bindings/error_page_binding.dart';
import '../modules/error_page/views/error_page_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/securite/bindings/securite_binding.dart';
import '../modules/securite/views/securite_view.dart';
import '../modules/settings/bindings/settings_binding.dart';
import '../modules/settings/views/settings_view.dart';
import '../modules/technicien/home/bindings/technicien_home_binding.dart';
import '../modules/technicien/home/views/technicien_home_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.LOGIN;

  static final routes = [
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.CLIENT_HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
      children: [],
    ),
    GetPage(
      name: _Paths.SECURITE,
      page: () => const SecuriteView(),
      binding: SecuriteBinding(),
    ),
    GetPage(
      name: _Paths.SETTINGS,
      page: () => const SettingsView(),
      binding: SettingsBinding(),
    ),
    GetPage(
      name: _Paths.CONSO,
      page: () => const ConsoView(),
      binding: ConsoBinding(),
    ),
    GetPage(
      name: _Paths.APPRO,
      page: () => const ApproView(),
      binding: ApproBinding(),
    ),
    GetPage(
      name: _Paths.ERROR_PAGE,
      page: () => const ErrorPageView(),
      binding: ErrorPageBinding(),
    ),
    GetPage(
      name: _Paths.TECHNICIEN_HOME,
      page: () => const TechnicienHomeView(),
      binding: TechnicienHomeBinding(),
    ),
  ];
}
