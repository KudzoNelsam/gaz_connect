import 'package:flutter/material.dart';
import 'package:gaz_connect/app/routes/app_pages.dart';
import 'package:gaz_connect/app/views/views/main_layout_view.dart';

import 'package:get/get.dart';

class TechView extends GetView {
  final Widget body;
  const TechView({required this.body, super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayoutView(
      title: "GazConnect",
      items: const [],
      itemLabels: [],
      body: body,
    );
    // return Text("data");
  }
}
