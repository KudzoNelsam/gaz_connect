import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gaz_connect/app/modules/settings/userProfile/user_profile_data.dart';
import 'package:get/get.dart';

class UserProfileController extends GetxController {
  var userProfile = Rx<UserProfileData?>(null);
  var isLoading = false.obs;
  var isEditing = false.obs;

  // Getters
  bool get hasUserProfile => userProfile.value != null;
  String get nomUtilisateur => userProfile.value?.nomComplet ?? 'Utilisateur';
  String get telephoneUtilisateur => userProfile.value?.telephoneFormate ?? '';
  String get initialesUtilisateur => userProfile.value?.initiales ?? 'NN';
  Color get couleurAvatar => userProfile.value?.couleurAvatar ?? Colors.blue;

  @override
  void onInit() {
    super.onInit();
    print(
      '[2025-06-09 12:52:38] nelsam12 - Initialisation UserProfileController',
    );
    loadUserProfile();
  }

  // ✅ Méthode principale - facile à remplacer par l'API plus tard
  Future<void> loadUserProfile() async {
    isLoading.value = true;

    try {
      // TODO: Remplacer par l'appel API
      // final response = await ApiService.getUserProfile('nelsam12');
      // userProfile.value = UserProfileData.fromJson(response.data);

      // ✅ DONNÉES DE TEST RÉALISTES (exactement comme votre image)
      await _loadTestUserProfile();

      print('[2025-06-09 12:52:38] nelsam12 - Profil utilisateur chargé');
    } catch (e) {
      print('[2025-06-09 12:52:38] nelsam12 - Erreur chargement profil: $e');
      _loadFallbackProfile();
    } finally {
      isLoading.value = false;
    }
  }

  // ✅ DONNÉES DE TEST - exactement comme votre image
  Future<void> _loadTestUserProfile() async {
    // Simulation délai réseau
    await Future.delayed(const Duration(milliseconds: 500));

    userProfile.value = UserProfileData(
      id: 'user_nelsam12',
      nomComplet: 'Mamadou Diallo', // ✅ Comme dans votre image
      telephone: '+22177XXXXXX', // ✅ Format masqué comme dans l'image
      email: 'mamadou.diallo@example.com',
      initiales: 'MD', // ✅ Comme dans votre image
      dateInscription: DateTime(2024, 1, 15),
      derniereConnexion: DateTime.now(),
      estActif: true,
      typeUtilisateur: UserType.client,
    );
  }

  void _loadFallbackProfile() {
    userProfile.value = UserProfileData(
      id: 'fallback',
      nomComplet: 'Utilisateur Inconnu',
      telephone: '+221XXXXXXX',
      email: 'inconnu@example.com',
      initiales: 'UI',
      dateInscription: DateTime.now(),
      derniereConnexion: DateTime.now(),
      estActif: false,
      typeUtilisateur: UserType.client,
    );
  }

  // ✅ Ouvrir l'édition du profil
  void ouvrirEditionProfil() {
    print('[2025-06-09 12:52:38] nelsam12 - Ouverture édition profil');

    isEditing.value = true;

    // TODO: Ouvrir un dialogue ou une page d'édition
    Get.snackbar(
      'Édition du profil',
      'Fonctionnalité d\'édition bientôt disponible - nelsam12',
      backgroundColor: Colors.blue,
      colorText: Colors.white,
      icon: const Icon(Icons.edit, color: Colors.white),
    );

    // Simulation
    Future.delayed(const Duration(seconds: 2), () {
      isEditing.value = false;
    });
  }

  // ✅ Déconnexion
  void deconnecter() {
    print('[2025-06-09 12:52:38] nelsam12 - Déconnexion demandée');

    Get.dialog(
      AlertDialog(
        title: const Text('Déconnexion'),
        content: const Text('Êtes-vous sûr de vouloir vous déconnecter ?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Annuler')),
          TextButton(
            onPressed: () {
              Get.back();
              _effectuerDeconnexion();
            },
            child: const Text(
              'Déconnecter',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _effectuerDeconnexion() {
    // TODO: Nettoyer les données et rediriger
    Get.snackbar(
      'Déconnexion',
      'À bientôt nelsam12 !',
      backgroundColor: Colors.orange,
      colorText: Colors.white,
      icon: const Icon(Icons.logout, color: Colors.white),
    );

    print('[2025-06-09 12:52:38] nelsam12 - Déconnexion effectuée');
  }

  // ✅ Changer de photo de profil
  void changerPhotoProfil() {
    print('[2025-06-09 12:52:38] nelsam12 - Changement photo profil');

    // TODO: Ouvrir sélecteur d'image
    Get.snackbar(
      'Photo de profil',
      'Sélection d\'image bientôt disponible - nelsam12',
      backgroundColor: Colors.green,
      colorText: Colors.white,
      icon: const Icon(Icons.camera_alt, color: Colors.white),
    );
  }

  // ✅ Mettre à jour les informations
  Future<void> mettreAJourProfil({
    String? nomComplet,
    String? telephone,
    String? email,
  }) async {
    if (userProfile.value == null) return;

    final profileActuel = userProfile.value!;

    try {
      // TODO: Appel API pour mise à jour
      await Future.delayed(const Duration(milliseconds: 800));

      userProfile.value = UserProfileData(
        id: profileActuel.id,
        nomComplet: nomComplet ?? profileActuel.nomComplet,
        telephone: telephone ?? profileActuel.telephone,
        email: email ?? profileActuel.email,
        avatar: profileActuel.avatar,
        initiales: _generateInitiales(nomComplet ?? profileActuel.nomComplet),
        dateInscription: profileActuel.dateInscription,
        derniereConnexion: DateTime.now(),
        estActif: profileActuel.estActif,
        typeUtilisateur: profileActuel.typeUtilisateur,
      );

      Get.snackbar(
        'Profil mis à jour',
        'Vos informations ont été sauvegardées - nelsam12',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      print('[2025-06-09 12:52:38] nelsam12 - Profil mis à jour avec succès');
    } catch (e) {
      print('[2025-06-09 12:52:38] nelsam12 - Erreur mise à jour profil: $e');
      Get.snackbar(
        'Erreur',
        'Impossible de mettre à jour le profil',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  String _generateInitiales(String nomComplet) {
    List<String> mots = nomComplet.trim().split(' ');
    if (mots.length >= 2) {
      return '${mots[0][0]}${mots[1][0]}'.toUpperCase();
    } else if (mots.isNotEmpty && mots[0].length >= 2) {
      return mots[0].substring(0, 2).toUpperCase();
    }
    return 'NU';
  }

  // ✅ MÉTHODE POUR LE FUTUR BACKEND
  /*
  Future<void> loadFromBackend() async {
    try {
      isLoading.value = true;
      
      final response = await http.get(
        Uri.parse('$baseUrl/api/users/profile'),
        headers: {
          'Authorization': 'Bearer $userToken',
          'Content-Type': 'application/json',
        },
        queryParameters: {
          'userId': 'nelsam12',
        },
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        userProfile.value = UserProfileData.fromJson(data['profile']);
        
        print('[2025-06-09 12:52:38] nelsam12 - Profil backend chargé');
      } else {
        throw Exception('Erreur API: ${response.statusCode}');
      }
      
    } catch (e) {
      print('[2025-06-09 12:52:38] nelsam12 - Erreur backend profil: $e');
      _loadFallbackProfile();
    } finally {
      isLoading.value = false;
    }
  }
  */

  // ✅ Refresh manuel
  @override
  Future<void> refresh() async {
    print('[2025-06-09 12:52:38] nelsam12 - Refresh des données profil');
    await loadUserProfile();
  }
}
