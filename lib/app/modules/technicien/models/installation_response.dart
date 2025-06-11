class InstallationResponse {
  final int id;
  final String nomComplet;
  final String adresse;
  final String telephone;
  final int nbrCapteur;
  final int nbrBouteilles;
  final String statut; // "terminé" ou "programmé"

  InstallationResponse({
    required this.id,
    required this.nomComplet,
    required this.adresse,
    required this.telephone,
    required this.nbrCapteur,
    required this.nbrBouteilles,
    required this.statut,
  });
}