import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../core/constants/enums.dart';



@HiveType(typeId: 2)
class Item {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  String nome;
  
  @HiveField(2)
  double quantidade;
  
  @HiveField(3)
  String unidade;
  
  @HiveField(4)
  bool comprado;
  
  @HiveField(5)
  DateTime? compradoEm;
  
  @HiveField(6)
  double? precoPago;
  
  @HiveField(7)
  String categoriaId;
  
  @HiveField(8)
  String listaId;
  
  @HiveField(9)
  DateTime criadoEm;
  
  @HiveField(10)
  DateTime? atualizadoEm;
  
  Item({
    String? id,
    required this.nome,
    this.quantidade = 1.0,
    this.unidade = 'un',
    this.comprado = false,
    this.compradoEm,
    this.precoPago,
    required this.categoriaId,
    required this.listaId,
    DateTime? criadoEm,
    this.atualizadoEm,
  }) : id = id ?? const Uuid().v4(),
       criadoEm = criadoEm ?? DateTime.now();
  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'quantidade': quantidade,
      'unidade': unidade,
      'comprado': comprado,
      'compradoEm': compradoEm?.toIso8601String(),
      'precoPago': precoPago,
      'categoriaId': categoriaId,
      'listaId': listaId,
      'criadoEm': criadoEm.toIso8601String(),
      'atualizadoEm': atualizadoEm?.toIso8601String(),
    };
  }
  
  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      id: map['id'],
      nome: map['nome'],
      quantidade: map['quantidade'] ?? 1.0,
      unidade: map['unidade'] ?? 'un',
      comprado: map['comprado'] ?? false,
      compradoEm: map['compradoEm'] != null 
          ? DateTime.parse(map['compradoEm']) 
          : null,
      precoPago: map['precoPago'],
      categoriaId: map['categoriaId'],
      listaId: map['listaId'],
      criadoEm: DateTime.parse(map['criadoEm']),
      atualizadoEm: map['atualizadoEm'] != null 
          ? DateTime.parse(map['atualizadoEm']) 
          : null,
    );
  }
  
  Item copyWith({
    String? nome,
    double? quantidade,
    String? unidade,
    bool? comprado,
    DateTime? compradoEm,
    double? precoPago,
    String? categoriaId,
    DateTime? atualizadoEm,
  }) {
    return Item(
      id: id,
      nome: nome ?? this.nome,
      quantidade: quantidade ?? this.quantidade,
      unidade: unidade ?? this.unidade,
      comprado: comprado ?? this.comprado,
      compradoEm: compradoEm ?? this.compradoEm,
      precoPago: precoPago ?? this.precoPago,
      categoriaId: categoriaId ?? this.categoriaId,
      listaId: listaId,
      criadoEm: criadoEm,
      atualizadoEm: atualizadoEm ?? DateTime.now(),
    );
  }
  
  String get quantidadeFormatada {
    if (quantidade == quantidade.toInt()) {
      return '${quantidade.toInt()} $unidade';
    }
    return '${quantidade.toStringAsFixed(2)} $unidade';
  }
  
  StatusItem get status => comprado ? StatusItem.comprado : StatusItem.pendente;
}