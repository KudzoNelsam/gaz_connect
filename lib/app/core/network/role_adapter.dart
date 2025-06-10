import 'package:hive/hive.dart';
import 'role.dart'; // ton enum

class RoleAdapter extends TypeAdapter<Role> {
  @override
  final int typeId = 3; // 👈 choisis un ID unique

  @override
  Role read(BinaryReader reader) {
    final value = reader.readString();
    return Role.get(value)!; // 👈 reconvertit en enum
  }

  @override
  void write(BinaryWriter writer, Role obj) {
    writer.writeString(obj.value); // 👈 enregistre la string "Admin", etc.
  }
}
