import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';


@HiveType(typeId: 3)
class HistoricoPreco {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  String produtoNome;
  
  @HiveField(2)
  double preco;
  
  @HiveField(3)
  String unidade;
  
  @HiveField(4)
  DateTime data;
  
  @HiveField(5)
  String listaId;
  
  HistoricoPreco({
    String? id,
    required this.produtoNome,
    required this.preco,
    required this.unidade,
    required this.data,
    required this.listaId,
  }) : id = id ?? const Uuid().v4();
  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'produtoNome': produtoNome,
      'preco': preco,
      'unidade': unidade,
      'data': data.toIso8601String(),
      'listaId': listaId,
    };
  }
  
  factory HistoricoPreco.fromMap(Map<String, dynamic> map) {
    return HistoricoPreco(
      id: map['id'],
      produtoNome: map['produtoNome'],
      preco: map['preco'],
      unidade: map['unidade'],
      data: DateTime.parse(map['data']),
      listaId: map['listaId'],
    );
  }
}