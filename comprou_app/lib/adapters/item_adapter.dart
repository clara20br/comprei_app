import 'package:hive/hive.dart';
import '../models/item.dart';

class ItemAdapter extends TypeAdapter<Item> {
  @override
  final int typeId = 2;

  @override
  Item read(BinaryReader reader) {
    return Item(
      id: reader.readString(),
      nome: reader.readString(),
      quantidade: reader.readDouble(),
      unidade: reader.readString(),
      comprado: reader.readBool(),
      compradoEm: reader.readBool() ? DateTime.parse(reader.readString()) : null,
      precoPago: reader.readBool() ? reader.readDouble() : null,
      categoriaId: reader.readString(),
      listaId: reader.readString(),
      criadoEm: DateTime.parse(reader.readString()),
      atualizadoEm: reader.readBool() ? DateTime.parse(reader.readString()) : null,
    );
  }

  @override
  void write(BinaryWriter writer, Item obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.nome);
    writer.writeDouble(obj.quantidade);
    writer.writeString(obj.unidade);
    writer.writeBool(obj.comprado);
    writer.writeBool(obj.compradoEm != null);
    if (obj.compradoEm != null) {
      writer.writeString(obj.compradoEm!.toIso8601String());
    }
    writer.writeBool(obj.precoPago != null);
    if (obj.precoPago != null) {
      writer.writeDouble(obj.precoPago!);
    }
    writer.writeString(obj.categoriaId);
    writer.writeString(obj.listaId);
    writer.writeString(obj.criadoEm.toIso8601String());
    writer.writeBool(obj.atualizadoEm != null);
    if (obj.atualizadoEm != null) {
      writer.writeString(obj.atualizadoEm!.toIso8601String());
    }
  }
}