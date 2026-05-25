// lib/models/usuario.dart
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

// Removemos a linha 'part 'usuario.g.dart';' pois vamos usar o adapter manual

@HiveType(typeId: 5)
class Usuario {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  String nome;
  
  @HiveField(2)
  String? email;
  
  @HiveField(3)
  String? fotoPath;
  
  @HiveField(4)
  DateTime criadoEm;
  
  @HiveField(5)
  DateTime? ultimoAcesso;
  
  @HiveField(6)
  PreferenciasUsuario preferencias;
  
  @HiveField(7)
  EstatisticasUsuario estatisticas;
  
  Usuario({
    String? id,
    required this.nome,
    this.email,
    this.fotoPath,
    DateTime? criadoEm,
    this.ultimoAcesso,
    PreferenciasUsuario? preferencias,
    EstatisticasUsuario? estatisticas,
  }) : id = id ?? const Uuid().v4(),
       criadoEm = criadoEm ?? DateTime.now(),
       preferencias = preferencias ?? PreferenciasUsuario.padrao(),
       estatisticas = estatisticas ?? EstatisticasUsuario.vazio();
  
  factory Usuario.padrao() {
    return Usuario(
      nome: 'Usuário',
      email: null,
      fotoPath: null,
    );
  }
  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'fotoPath': fotoPath,
      'criadoEm': criadoEm.toIso8601String(),
      'ultimoAcesso': ultimoAcesso?.toIso8601String(),
      'preferencias': preferencias.toMap(),
      'estatisticas': estatisticas.toMap(),
    };
  }
  
  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      id: map['id'],
      nome: map['nome'],
      email: map['email'],
      fotoPath: map['fotoPath'],
      criadoEm: DateTime.parse(map['criadoEm']),
      ultimoAcesso: map['ultimoAcesso'] != null 
          ? DateTime.parse(map['ultimoAcesso']) 
          : null,
      preferencias: PreferenciasUsuario.fromMap(map['preferencias']),
      estatisticas: EstatisticasUsuario.fromMap(map['estatisticas']),
    );
  }
  
  Usuario copyWith({
    String? nome,
    String? email,
    String? fotoPath,
    DateTime? ultimoAcesso,
    PreferenciasUsuario? preferencias,
    EstatisticasUsuario? estatisticas,
  }) {
    return Usuario(
      id: id,
      nome: nome ?? this.nome,
      email: email ?? this.email,
      fotoPath: fotoPath ?? this.fotoPath,
      criadoEm: criadoEm,
      ultimoAcesso: ultimoAcesso ?? this.ultimoAcesso,
      preferencias: preferencias ?? this.preferencias,
      estatisticas: estatisticas ?? this.estatisticas,
    );
  }
}

@HiveType(typeId: 6)
class PreferenciasUsuario {
  @HiveField(0)
  bool notificacoes;
  
  @HiveField(1)
  bool backupAutomatico;
  
  @HiveField(2)
  String moedaPadrao;
  
  @HiveField(3)
  String unidadePadrao;
  
  PreferenciasUsuario({
    this.notificacoes = true,
    this.backupAutomatico = false,
    this.moedaPadrao = 'BRL',
    this.unidadePadrao = 'kg',
  });
  
  factory PreferenciasUsuario.padrao() => PreferenciasUsuario();
  
  Map<String, dynamic> toMap() {
    return {
      'notificacoes': notificacoes,
      'backupAutomatico': backupAutomatico,
      'moedaPadrao': moedaPadrao,
      'unidadePadrao': unidadePadrao,
    };
  }
  
  factory PreferenciasUsuario.fromMap(Map<String, dynamic> map) {
    return PreferenciasUsuario(
      notificacoes: map['notificacoes'] ?? true,
      backupAutomatico: map['backupAutomatico'] ?? false,
      moedaPadrao: map['moedaPadrao'] ?? 'BRL',
      unidadePadrao: map['unidadePadrao'] ?? 'kg',
    );
  }
  
  PreferenciasUsuario copyWith({
    bool? notificacoes,
    bool? backupAutomatico,
    String? moedaPadrao,
    String? unidadePadrao,
  }) {
    return PreferenciasUsuario(
      notificacoes: notificacoes ?? this.notificacoes,
      backupAutomatico: backupAutomatico ?? this.backupAutomatico,
      moedaPadrao: moedaPadrao ?? this.moedaPadrao,
      unidadePadrao: unidadePadrao ?? this.unidadePadrao,
    );
  }
}

@HiveType(typeId: 7)
class EstatisticasUsuario {
  @HiveField(0)
  int totalListasCriadas;
  
  @HiveField(1)
  int totalItensComprados;
  
  @HiveField(2)
  double totalGasto;
  
  @HiveField(3)
  int diasConsecutivosUso;
  
  @HiveField(4)
  DateTime? ultimaCompra;
  
  EstatisticasUsuario({
    this.totalListasCriadas = 0,
    this.totalItensComprados = 0,
    this.totalGasto = 0.0,
    this.diasConsecutivosUso = 0,
    this.ultimaCompra,
  });
  
  factory EstatisticasUsuario.vazio() => EstatisticasUsuario();
  
  Map<String, dynamic> toMap() {
    return {
      'totalListasCriadas': totalListasCriadas,
      'totalItensComprados': totalItensComprados,
      'totalGasto': totalGasto,
      'diasConsecutivosUso': diasConsecutivosUso,
      'ultimaCompra': ultimaCompra?.toIso8601String(),
    };
  }
  
  factory EstatisticasUsuario.fromMap(Map<String, dynamic> map) {
    return EstatisticasUsuario(
      totalListasCriadas: map['totalListasCriadas'] ?? 0,
      totalItensComprados: map['totalItensComprados'] ?? 0,
      totalGasto: map['totalGasto'] ?? 0.0,
      diasConsecutivosUso: map['diasConsecutivosUso'] ?? 0,
      ultimaCompra: map['ultimaCompra'] != null 
          ? DateTime.parse(map['ultimaCompra']) 
          : null,
    );
  }
  
  EstatisticasUsuario copyWith({
    int? totalListasCriadas,
    int? totalItensComprados,
    double? totalGasto,
    int? diasConsecutivosUso,
    DateTime? ultimaCompra,
  }) {
    return EstatisticasUsuario(
      totalListasCriadas: totalListasCriadas ?? this.totalListasCriadas,
      totalItensComprados: totalItensComprados ?? this.totalItensComprados,
      totalGasto: totalGasto ?? this.totalGasto,
      diasConsecutivosUso: diasConsecutivosUso ?? this.diasConsecutivosUso,
      ultimaCompra: ultimaCompra ?? this.ultimaCompra,
    );
  }
}