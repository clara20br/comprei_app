import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import '../models/categoria.dart';

class CategoriaAdapter extends TypeAdapter<Categoria> {
  @override
  final int typeId = 1;

  @override
  Categoria read(BinaryReader reader) {
    return Categoria(
      id: reader.readString(),
      nome: reader.readString(),
      emoji: reader.readString(),
      cor: Color(reader.readInt()),
      isDefault: reader.readBool(),
      ordem: reader.readInt(),
      itensIds: reader.readList().cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, Categoria obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.nome);
    writer.writeString(obj.emoji);
    writer.writeInt(obj.corValue);
    writer.writeBool(obj.isDefault);
    writer.writeInt(obj.ordem);
    writer.writeList(obj.itensIds);
  }
}