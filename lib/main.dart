import 'package:flutter/material.dart';
import 'package:gaz_connect/app/controllers/navigation_controller.dart';

import 'package:get/get.dart';

import 'app/routes/app_pages.dart';

void main() {
  Get.put(NavigationController());
  runApp(
    GetMaterialApp(
      title: "Application",
      theme: ThemeData(
        primaryColor: Color(0xFFE0B219),
        scaffoldBackgroundColor: Color(0xFFF8FAFC),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFFFF7F00),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          selectedItemColor: Color(0xFFFF7F00),
        ),
      ),
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}
