import 'package:hive/hive.dart';
import '../core/constants/enums.dart';



@HiveType(typeId: 4)
class Configuracao {
  @HiveField(0)
  TemaApp tema;
  
  @HiveField(1)
  bool notificacoes;
  
  @HiveField(2)
  bool backupAutomatico;
  
  @HiveField(3)
  DateTime? ultimoBackup;
  
  Configuracao({
    this.tema = TemaApp.sistema,
    this.notificacoes = true,
    this.backupAutomatico = false,
    this.ultimoBackup,
  });
  
  Configuracao copyWith({
    TemaApp? tema,
    bool? notificacoes,
    bool? backupAutomatico,
    DateTime? ultimoBackup,
  }) {
    return Configuracao(
      tema: tema ?? this.tema,
      notificacoes: notificacoes ?? this.notificacoes,
      backupAutomatico: backupAutomatico ?? this.backupAutomatico,
      ultimoBackup: ultimoBackup ?? this.ultimoBackup,
    );
  }
}