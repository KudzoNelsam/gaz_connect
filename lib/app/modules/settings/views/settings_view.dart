import 'package:flutter/material.dart';
import 'package:gaz_connect/app/modules/settings/capteurs/capteurs_controller.dart';
import 'package:gaz_connect/app/modules/settings/capteurs/get_capteurs_info.dart';
import 'package:gaz_connect/app/modules/settings/userProfile/get_user_profile.dart';
import 'package:gaz_connect/app/modules/settings/userProfile/user_profile_controller.dart';
import 'package:gaz_connect/app/views/views/client_view.dart';

import 'package:get/get.dart';

import '../controllers/settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});
  @override
  Widget build(BuildContext context) {
    final UserProfileController userProfileController = Get.put(
      UserProfileController(),
    );
    final CapteursController capteursController = Get.put(
      CapteursController(),
    ); // ✅ Nouveau

    final body = SingleChildScrollView(
      child: Column(
        children: [
          getUserProfileWidget(userProfileController),
          getCapteursWidget(capteursController), // ✅ Nouveau widget
        ],
      ),
    );
    return ClientView(body: body);
  }
}
