import 'package:hive/hive.dart';
import '../models/lista_compras.dart';
import '../core/constants/enums.dart';

class ListaComprasAdapter extends TypeAdapter<ListaCompras> {
  @override
  final int typeId = 0;

  @override
  ListaCompras read(BinaryReader reader) {
    return ListaCompras(
      id: reader.readString(),
      nome: reader.readString(),
      tipo: TipoLista.values[reader.readInt()],
      criadoEm: DateTime.parse(reader.readString()),
      atualizadoEm: reader.readBool() ? DateTime.parse(reader.readString()) : null,
      categoriasIds: reader.readList().cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, ListaCompras obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.nome);
    writer.writeInt(obj.tipo.index);
    writer.writeString(obj.criadoEm.toIso8601String());
    writer.writeBool(obj.atualizadoEm != null);
    if (obj.atualizadoEm != null) {
      writer.writeString(obj.atualizadoEm!.toIso8601String());
    }
    writer.writeList(obj.categoriasIds);
  }
}