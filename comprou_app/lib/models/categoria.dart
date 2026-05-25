import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../core/themes/cores.dart';


@HiveType(typeId: 1)
class Categoria {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  String nome;
  
  @HiveField(2)
  String emoji;
  
  @HiveField(3)
  int corValue;
  
  @HiveField(4)
  bool isDefault;
  
  @HiveField(5)
  int ordem;
  
  @HiveField(6)
  List<String> itensIds;
  
  Color get cor => Color(corValue);
  
  Categoria({
    String? id,
    required this.nome,
    required this.emoji,
    Color? cor,
    this.isDefault = false,
    this.ordem = 0,
    this.itensIds = const [],
  }) : id = id ?? const Uuid().v4(),
       corValue = (cor ?? AppCores.verdePastel).value;
  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'emoji': emoji,
      'corValue': corValue,
      'isDefault': isDefault,
      'ordem': ordem,
      'itensIds': itensIds,
    };
  }
  
  factory Categoria.fromMap(Map<String, dynamic> map) {
    return Categoria(
      id: map['id'],
      nome: map['nome'],
      emoji: map['emoji'],
      cor: Color(map['corValue']),
      isDefault: map['isDefault'] ?? false,
      ordem: map['ordem'] ?? 0,
      itensIds: List<String>.from(map['itensIds'] ?? []),
    );
  }
  
  Categoria copyWith({
    String? nome,
    String? emoji,
    Color? cor,
    int? ordem,
    List<String>? itensIds,
  }) {
    return Categoria(
      id: id,
      nome: nome ?? this.nome,
      emoji: emoji ?? this.emoji,
      cor: cor ?? this.cor,
      isDefault: isDefault,
      ordem: ordem ?? this.ordem,
      itensIds: itensIds ?? this.itensIds,
    );
  }
}