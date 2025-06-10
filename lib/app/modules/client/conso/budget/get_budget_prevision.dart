import 'package:flutter/material.dart';
import 'package:gaz_connect/app/modules/client/conso/budget/budget_controller.dart';
import 'package:get/get.dart';

Widget getBudgetPrevision(BudgetController controller) {
  return Container(
    margin: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border(
        left: BorderSide(
          color: Colors.blue,
          width: 4,
        ), // ✅ Bordure bleue à gauche comme dans l'image
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          spreadRadius: 1,
          blurRadius: 5,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Titre avec icône (exactement comme l'image)
          Row(
            children: [
              Icon(Icons.calendar_month, color: Colors.blue, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Obx(
                  () => Text(
                    controller.periodLabel,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
              // Bouton refresh optionnel
              IconButton(
                onPressed: () => controller.refresh(),
                icon: const Icon(Icons.refresh, size: 18, color: Colors.grey),
                tooltip: 'Actualiser',
                constraints: const BoxConstraints(),
                padding: EdgeInsets.zero,
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Contenu du budget
          Obx(
            () => controller.isLoading.value
                ? _buildLoadingState()
                : controller.hasBudgetData
                ? _buildBudgetContent(controller)
                : _buildEmptyState(),
          ),
        ],
      ),
    ),
  );
}

Widget _buildLoadingState() {
  return const SizedBox(
    height: 120,
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 12),
          Text(
            'Calcul des prévisions...',
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
        ],
      ),
    ),
  );
}

Widget _buildEmptyState() {
  return SizedBox(
    height: 120,
    child: const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 40, color: Colors.grey),
          SizedBox(height: 8),
          Text(
            'Données non disponibles',
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          Text('nelsam12', style: TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    ),
  );
}

Widget _buildBudgetContent(BudgetController controller) {
  return Column(
    children: [
      // Budget prévu
      _buildBudgetRow(
        'Budget prévu',
        controller.budgetPrevuFormatted,
        Colors.black87,
        FontWeight.w500,
      ),

      const SizedBox(height: 16),

      // Mois actuel
      _buildBudgetRow(
        'Mois actuel',
        controller.moisActuelFormatted,
        Colors.black87,
        FontWeight.w500,
      ),

      const SizedBox(height: 16),

      // Mois dernier avec tendance
      _buildBudgetRow(
        'Mois dernier',
        controller.moisDernierFormatted,
        controller.moisDernierColor, // ✅ Couleur selon la tendance
        FontWeight.w500,
      ),

      // Ligne de séparation optionnelle
      const SizedBox(height: 16),
      Divider(color: Colors.grey[200], height: 1),
      const SizedBox(height: 12),

      // Informations supplémentaires
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            controller.getMessageEconomie(),
            style: TextStyle(
              fontSize: 12,
              color: controller.estSousLeBudget ? Colors.green : Colors.orange,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            '${controller.getPourcentageUtilise().toStringAsFixed(1)}% utilisé',
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
        ],
      ),
    ],
  );
}

Widget _buildBudgetRow(
  String label,
  String montant,
  Color couleur,
  FontWeight poids,
) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        label,
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey[600],
          fontWeight: FontWeight.w400,
        ),
      ),
      Text(
        montant,
        style: TextStyle(fontSize: 16, color: couleur, fontWeight: poids),
      ),
    ],
  );
}
