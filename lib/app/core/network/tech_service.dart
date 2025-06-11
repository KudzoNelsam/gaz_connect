import 'package:gaz_connect/app/core/login/rest_response.dart';

import '../../modules/technicien/models/client_details_dto_page.dart';
import '../../modules/technicien/models/installation_response.dart';

abstract class TechService {
  Future<RestResponse> getInstallations();
  Future<List<InstallationResponse>> getInstallationsToday();
  Future<ClientDetailsDtoPage> getClientDetails(int clientId);
  Future<bool> ajouterBouteille(int clientId, BouteilleRequest request);
  Future<bool> terminerInstallation(int installationId);
}