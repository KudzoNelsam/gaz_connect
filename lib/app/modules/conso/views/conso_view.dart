import 'package:flutter/material.dart';
import 'package:gaz_connect/app/modules/conso/budget/budget_controller.dart';
import 'package:gaz_connect/app/modules/conso/budget/get_budget_prevision.dart';
import 'package:gaz_connect/app/modules/conso/charts/consumption_controller.dart';
import 'package:gaz_connect/app/modules/conso/charts/get_consumption_chart.dart';
import 'package:gaz_connect/app/modules/conso/comparaison/comparaison_controller.dart';
import 'package:gaz_connect/app/modules/conso/comparaison/get_comparaison.dart';
import 'package:gaz_connect/app/modules/conso/conseil/conseil_controller.dart';
import 'package:gaz_connect/app/modules/conso/conseil/get_conseil.dart';
import 'package:gaz_connect/app/views/views/client_view.dart';

import 'package:get/get.dart';

import '../controllers/conso_controller.dart';

class ConsoView extends GetView<ConsoController> {
  const ConsoView({super.key});
  @override
  Widget build(BuildContext context) {
    final ConsumptionController controller = Get.put(ConsumptionController());
    final ComparisonController comparisonController = Get.put(
      ComparisonController(),
    );
    final ConseilsController conseilsController = Get.put(ConseilsController());
    final BudgetController budgetController = Get.put(BudgetController());
    final body = SingleChildScrollView(
      child: Column(
        children: [
          // Votre widget de consommation - reproduction exacte de l'image
          getConsumptionChart(controller),
          getBudgetPrevision(budgetController),
          getComparison(comparisonController),
          getConseilsSemaine(conseilsController), // ✅ Nouveau widget
        ],
      ),
    );
    return ClientView(body: body);
  }
}
