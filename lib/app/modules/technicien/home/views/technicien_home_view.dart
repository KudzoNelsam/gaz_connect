import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/technicien_home_controller.dart';

class TechnicienHomeView extends GetView<TechnicienController> {
  const TechnicienHomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GazConnect'), centerTitle: true),
      body: const Center(
        child: Text(
          'TechnicienHomeView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
