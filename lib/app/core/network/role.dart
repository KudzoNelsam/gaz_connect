enum Role {
  ADMIN("Admin"),
  CLIENT("Client"),
  TECHNICIEN("Technicien");

  final String value;

  const Role(this.value);

  static Role? get(String statut) {
    for (var s in Role.values) {
      if (s.value == statut) {
        return s;
      }
    }
    return null;
  }
}
