// views/ajouter_bouteille_view.dart
import 'package:flutter/material.dart';
import 'package:gaz_connect/app/core/network/impl/tech_service_impl.dart';
import 'package:gaz_connect/app/core/network/tech_service.dart';
import 'package:get/get.dart';

import '../models/client_details_dto_page.dart';

class AjouterBouteilleView extends StatefulWidget {
  final int clientId;
  final List<int> typesBouteille;

  const AjouterBouteilleView({
    super.key,
    required this.clientId,
    required this.typesBouteille,
  });

  @override
  _AjouterBouteilleViewState createState() => _AjouterBouteilleViewState();
}

class _AjouterBouteilleViewState extends State<AjouterBouteilleView> {
  final TechService techService = Get.find<TechServiceImpl>();
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _capteurController = TextEditingController();

  int? _selectedPoids;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Ajouter les listeners pour mettre à jour le bouton
    _nomController.addListener(_updateButtonState);
    _capteurController.addListener(_updateButtonState);
  }

  @override
  void dispose() {
    // Supprimer les listeners avant de disposer
    _nomController.removeListener(_updateButtonState);
    _capteurController.removeListener(_updateButtonState);
    _nomController.dispose();
    _capteurController.dispose();
    super.dispose();
  }

  // Méthode pour déclencher la mise à jour du bouton
  void _updateButtonState() {
    setState(() {
      // Cette méthode déclenche juste un rebuild pour mettre à jour isFormValid
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1976D2),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ajouter une bouteille',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'Nouvelle bouteille connectée',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        titleSpacing: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildIntroCard(),
            const SizedBox(height: 24),
            _buildInformationsSection(),
            const SizedBox(height: 24),
            _buildCapteurSection(),
            const SizedBox(height: 32),
            _buildValidationButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildIntroCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: const Border(
          left: BorderSide(color: Color(0xFF1976D2), width: 4),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Création d\'une bouteille',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1976D2),
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Définissez les caractéristiques de la bouteille et associez-la à un capteur déjà configuré.',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF6B7280),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInformationsSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.info_outline, color: Color(0xFF1976D2), size: 20),
                const SizedBox(width: 8),
                const Text(
                  'Informations de la bouteille',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1976D2),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Nom de la bouteille
            const Text(
              'Nom de la bouteille',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF374151),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _nomController,
              decoration: InputDecoration(
                hintText: 'Ex: Terrasse, Cuisine, Salon...',
                hintStyle: TextStyle(color: Colors.grey[400]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFF1976D2)),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 16,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Choisissez un nom descriptif de l\'emplacement',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[500],
              ),
            ),

            const SizedBox(height: 20),

            // Type de bouteille
            const Text(
              'Type de bouteille',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF374151),
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<int>(
              value: _selectedPoids,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFF1976D2)),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 16,
                ),
              ),
              hint: const Text('Sélectionnez le type'),
              items: widget.typesBouteille.map((poids) {
                return DropdownMenuItem<int>(
                  value: poids,
                  child: Text('$poids kg'),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedPoids = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCapteurSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.link, color: Color(0xFF1976D2), size: 20),
                const SizedBox(width: 8),
                const Text(
                  'Associer un capteur',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1976D2),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            const Text(
              'Capteur disponible',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF374151),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _capteurController,
              decoration: InputDecoration(
                hintText: 'Saisissez l\'ID du capteur',
                hintStyle: TextStyle(color: Colors.grey[400]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFF1976D2)),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 16,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Seuls les capteurs configurés apparaissent',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildValidationButton() {
    // Améliorer la validation avec trim()
    final bool isFormValid = _nomController.text.trim().isNotEmpty &&
        _selectedPoids != null &&
        _capteurController.text.trim().isNotEmpty;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: isFormValid && !_isLoading ? _validerCreation : null,
        icon: _isLoading
            ? const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        )
            : const Icon(Icons.check, color: Colors.white),
        label: Text(_isLoading ? 'Création en cours...' : 'Valider la création'),
        style: ElevatedButton.styleFrom(
          backgroundColor: isFormValid && !_isLoading
              ? const Color(0xFF1976D2)
              : Colors.grey[300],
          foregroundColor: isFormValid && !_isLoading
              ? Colors.white
              : Colors.grey[600],
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  Future<void> _validerCreation() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final request = BouteilleRequest(
        poids: _selectedPoids!.toDouble(),
        nom: _nomController.text.trim(),
        capteurId: _capteurController.text.trim(),
      );

      final success = await techService.ajouterBouteille(widget.clientId, request);

      if (success) {
        Get.back(result: true); // Retourner avec indication de succès
        Get.snackbar(
          'Succès',
          'Bouteille ajoutée avec succès',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF10B981),
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Erreur',
          'Impossible d\'ajouter la bouteille',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Une erreur est survenue',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}