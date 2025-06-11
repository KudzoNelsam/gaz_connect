// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_connected.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserConnectedAdapter extends TypeAdapter<UserConnected> {
  @override
  final int typeId = 0;

  @override
  UserConnected read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserConnected(
      id: fields[0] as num,
      nomComplet: fields[1] as String,
      email: fields[2] as String,
      telephone: fields[3] as String,
      role: fields[4] as Role,
    );
  }

  @override
  void write(BinaryWriter writer, UserConnected obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.nomComplet)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.telephone)
      ..writeByte(4)
      ..write(obj.role);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserConnectedAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
