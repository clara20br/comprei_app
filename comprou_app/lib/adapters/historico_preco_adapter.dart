import 'package:hive/hive.dart';
import '../models/historico_preco.dart';

class HistoricoPrecoAdapter extends TypeAdapter<HistoricoPreco> {
  @override
  final int typeId = 3;

  @override
  HistoricoPreco read(BinaryReader reader) {
    return HistoricoPreco(
      id: reader.readString(),
      produtoNome: reader.readString(),
      preco: reader.readDouble(),
      unidade: reader.readString(),
      data: DateTime.parse(reader.readString()),
      listaId: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, HistoricoPreco obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.produtoNome);
    writer.writeDouble(obj.preco);
    writer.writeString(obj.unidade);
    writer.writeString(obj.data.toIso8601String());
    writer.writeString(obj.listaId);
  }
}