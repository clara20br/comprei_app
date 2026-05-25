// lib/adapters/usuario_adapter.dart
import 'package:hive/hive.dart';
import '../models/usuario.dart';

class UsuarioAdapter extends TypeAdapter<Usuario> {
  @override
  final int typeId = 5;

  @override
  Usuario read(BinaryReader reader) {
    return Usuario(
      id: reader.readString(),
      nome: reader.readString(),
      email: reader.readBool() ? reader.readString() : null,
      fotoPath: reader.readBool() ? reader.readString() : null,
      criadoEm: DateTime.parse(reader.readString()),
      ultimoAcesso: reader.readBool() ? DateTime.parse(reader.readString()) : null,
      preferencias: reader.read() as PreferenciasUsuario,
      estatisticas: reader.read() as EstatisticasUsuario,
    );
  }

  @override
  void write(BinaryWriter writer, Usuario obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.nome);
    writer.writeBool(obj.email != null);
    if (obj.email != null) writer.writeString(obj.email!);
    writer.writeBool(obj.fotoPath != null);
    if (obj.fotoPath != null) writer.writeString(obj.fotoPath!);
    writer.writeString(obj.criadoEm.toIso8601String());
    writer.writeBool(obj.ultimoAcesso != null);
    if (obj.ultimoAcesso != null) writer.writeString(obj.ultimoAcesso!.toIso8601String());
    writer.write(obj.preferencias);
    writer.write(obj.estatisticas);
  }
}

class PreferenciasUsuarioAdapter extends TypeAdapter<PreferenciasUsuario> {
  @override
  final int typeId = 6;

  @override
  PreferenciasUsuario read(BinaryReader reader) {
    return PreferenciasUsuario(
      notificacoes: reader.readBool(),
      backupAutomatico: reader.readBool(),
      moedaPadrao: reader.readString(),
      unidadePadrao: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, PreferenciasUsuario obj) {
    writer.writeBool(obj.notificacoes);
    writer.writeBool(obj.backupAutomatico);
    writer.writeString(obj.moedaPadrao);
    writer.writeString(obj.unidadePadrao);
  }
}

class EstatisticasUsuarioAdapter extends TypeAdapter<EstatisticasUsuario> {
  @override
  final int typeId = 7;

  @override
  EstatisticasUsuario read(BinaryReader reader) {
    return EstatisticasUsuario(
      totalListasCriadas: reader.readInt(),
      totalItensComprados: reader.readInt(),
      totalGasto: reader.readDouble(),
      diasConsecutivosUso: reader.readInt(),
      ultimaCompra: reader.readBool() ? DateTime.parse(reader.readString()) : null,
    );
  }

  @override
  void write(BinaryWriter writer, EstatisticasUsuario obj) {
    writer.writeInt(obj.totalListasCriadas);
    writer.writeInt(obj.totalItensComprados);
    writer.writeDouble(obj.totalGasto);
    writer.writeInt(obj.diasConsecutivosUso);
    writer.writeBool(obj.ultimaCompra != null);
    if (obj.ultimaCompra != null) writer.writeString(obj.ultimaCompra!.toIso8601String());
  }
}