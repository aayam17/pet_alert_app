// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AuthApiModelAdapter extends TypeAdapter<AuthApiModel> {
  @override
  final int typeId = 0;

  @override
  AuthApiModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AuthApiModel(
      email: fields[0] as String,
      password: fields[1] as String,
      name: fields[2] as String,
      token: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, AuthApiModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.email)
      ..writeByte(1)
      ..write(obj.password)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.token);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthApiModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
