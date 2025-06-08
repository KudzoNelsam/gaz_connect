import 'package:flutter/material.dart';
import 'package:gaz_connect/app/controllers/navigation_controller.dart';

import 'package:get/get.dart';

class MainLayoutView extends GetView<NavigationController> {
  final Widget body;
  final String title;
  final List<BottomNavigationBarItem> items;
  final List<String> itemLabels;
  const MainLayoutView({
    required this.body,
    required this.title,
    required this.items,
    required this.itemLabels,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title), centerTitle: true),
      body: body,
      bottomNavigationBar: BottomNavigationBar(
        items: items,
        currentIndex: controller.getIndexForRoute(
          controller.currentRoute.value,
          itemLabels,
        ),
        onTap: (index) => controller.changePage(index, itemLabels),
      ),
    );
  }
}
