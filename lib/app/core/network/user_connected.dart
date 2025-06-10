import 'package:gaz_connect/app/core/network/impl/auth_service_auth_impl.dart';
import 'package:gaz_connect/app/core/network/role.dart';
import 'package:hive/hive.dart';

part 'user_connected.g.dart';

@HiveType(typeId: 0)
class UserConnected {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String nom;
  @HiveField(2)
  final String prenom;
  @HiveField(3)
  final String email;
  @HiveField(4)
  final String telephone;
  @HiveField(5)
  final Role role;

  UserConnected({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.email,
    required this.telephone,
    required this.role,
  });

  factory UserConnected.toEntity(Map<String, dynamic> response) {
    return UserConnected(
      id: response["id"] ?? "1",
      nom: response["nom"] ?? "Doe",
      prenom: response["prenom"] ?? "John",
      email: response["email"] ?? "john@doe",
      telephone: response["telephone"] ?? "+221 77 346 18 82",
      role: Role.get(response["role"])!,
    );
  }

  static UserConnected? getUserConnected() {
    return AuthServiceImpl().getUser();
  }
}
