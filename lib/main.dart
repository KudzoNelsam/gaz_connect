import 'package:flutter/material.dart';
import 'package:gaz_connect/app/controllers/navigation_controller.dart';
import 'package:gaz_connect/app/core/network/api_constant.dart';
import 'package:gaz_connect/app/core/network/impl/auth_service_auth_impl.dart';
import 'package:gaz_connect/app/core/network/role_adapter.dart';
import 'package:gaz_connect/app/core/network/user_connected.dart';
import 'package:gaz_connect/app/modules/settings/notification/notification_controller.dart';

import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app/routes/app_pages.dart';

void main() async {
  Get.put(NavigationController());
  Get.put(AuthServiceImpl()); // ✅ C'est tout !
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(UserConnectedAdapter());
  Hive.registerAdapter(RoleAdapter());

  await Hive.openBox(ApiConstants.boxName);

  // ✅ INITIALISER LE CONTROLLER GLOBAL EN PREMIER
  Get.put(NotificationSettingsController(), permanent: true);
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "GazConnect",
      theme: ThemeData(
        primaryColor: Color(0xFFFF7F00),
        scaffoldBackgroundColor: Color(0xFFF8FAFC),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF004A99),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          selectedItemColor: Color(0xFF004A99),
        ),
      ),
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}
