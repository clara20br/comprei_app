import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../core/constants/enums.dart';


@HiveType(typeId: 0)
class ListaCompras {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  String nome;
  
  @HiveField(2)
  TipoLista tipo;
  
  @HiveField(3)
  DateTime criadoEm;
  
  @HiveField(4)
  DateTime? atualizadoEm;
  
  @HiveField(5)
  List<String> categoriasIds;
  
  ListaCompras({
    String? id,
    required this.nome,
    this.tipo = TipoLista.avulsa,
    DateTime? criadoEm,
    this.atualizadoEm,
    this.categoriasIds = const [],
  }) : id = id ?? const Uuid().v4(),
       criadoEm = criadoEm ?? DateTime.now();
  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'tipo': tipo.index,
      'criadoEm': criadoEm.toIso8601String(),
      'atualizadoEm': atualizadoEm?.toIso8601String(),
      'categoriasIds': categoriasIds,
    };
  }
  
  factory ListaCompras.fromMap(Map<String, dynamic> map) {
    return ListaCompras(
      id: map['id'],
      nome: map['nome'],
      tipo: TipoLista.values[map['tipo']],
      criadoEm: DateTime.parse(map['criadoEm']),
      atualizadoEm: map['atualizadoEm'] != null 
          ? DateTime.parse(map['atualizadoEm']) 
          : null,
      categoriasIds: List<String>.from(map['categoriasIds']),
    );
  }
  
  ListaCompras copyWith({
    String? nome,
    TipoLista? tipo,
    DateTime? atualizadoEm,
    List<String>? categoriasIds,
  }) {
    return ListaCompras(
      id: id,
      nome: nome ?? this.nome,
      tipo: tipo ?? this.tipo,
      criadoEm: criadoEm,
      atualizadoEm: atualizadoEm ?? DateTime.now(),
      categoriasIds: categoriasIds ?? this.categoriasIds,
    );
  }
}