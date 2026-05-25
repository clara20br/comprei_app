import 'package:flutter/material.dart';
import '../models/item.dart';
import '../services/database_service.dart';
import '../services/preco_service.dart';

class ItemProvider extends ChangeNotifier {
  List<Item> _itens = [];
  
  List<Item> get itens => _itens;
  
  Future<void> carregarItens() async {
    _itens = DatabaseService.itens;
    notifyListeners();
  }
  
  List<Item> getItensPorLista(String listaId) {
    return _itens.where((item) => item.listaId == listaId).toList();
  }
  
  List<Item> getItensPorCategoria(String categoriaId) {
    return _itens.where((item) => item.categoriaId == categoriaId).toList();
  }
  
  Future<void> criarItem(Item item) async {
    await DatabaseService.salvarItem(item);
    await carregarItens();
  }
  
  Future<void> atualizarItem(Item item) async {
    await DatabaseService.salvarItem(item);
    await carregarItens();
  }
  
  Future<void> deletarItem(String id) async {
    await DatabaseService.deletarItem(id);
    await carregarItens();
  }
  
  Future<void> marcarComprado(Item item, {double? preco}) async {
    final itemAtualizado = item.copyWith(
      comprado: true,
      compradoEm: DateTime.now(),
      precoPago: preco,
    );
    
    await DatabaseService.salvarItem(itemAtualizado);
    
    if (preco != null) {
      await PrecoService.salvarPrecoItem(itemAtualizado);
    }
    
    await carregarItens();
  }
  
  Future<void> desmarcarComprado(Item item) async {
    final itemAtualizado = item.copyWith(
      comprado: false,
      compradoEm: null,
      precoPago: null,
    );
    
    await DatabaseService.salvarItem(itemAtualizado);
    await carregarItens();
  }
  
  double getTotalPorLista(String listaId) {
    return _itens
        .where((item) => item.listaId == listaId && item.comprado && item.precoPago != null)
        .fold(0, (sum, item) => sum + (item.precoPago ?? 0));
  }
  
  Map<String, double> getTotaisPorCategoria(String listaId) {
    final Map<String, double> totais = {};
    for (var item in _itens) {
      if (item.listaId == listaId && item.comprado && item.precoPago != null) {
        totais[item.categoriaId] = (totais[item.categoriaId] ?? 0) + (item.precoPago ?? 0);
      }
    }
    return totais;
  }
}