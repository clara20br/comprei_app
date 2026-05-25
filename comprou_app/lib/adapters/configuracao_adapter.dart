import 'package:hive/hive.dart';
import '../models/configuracao.dart';
import '../core/constants/enums.dart';

class ConfiguracaoAdapter extends TypeAdapter<Configuracao> {
  @override
  final int typeId = 4;

  @override
  Configuracao read(BinaryReader reader) {
    return Configuracao(
      tema: TemaApp.values[reader.readInt()],
      notificacoes: reader.readBool(),
      backupAutomatico: reader.readBool(),
      ultimoBackup: reader.readBool() ? DateTime.parse(reader.readString()) : null,
    );
  }

  @override
  void write(BinaryWriter writer, Configuracao obj) {
    writer.writeInt(obj.tema.index);
    writer.writeBool(obj.notificacoes);
    writer.writeBool(obj.backupAutomatico);
    writer.writeBool(obj.ultimoBackup != null);
    if (obj.ultimoBackup != null) {
      writer.writeString(obj.ultimoBackup!.toIso8601String());
    }
  }
}