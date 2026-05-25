import 'package:flutter/material.dart';
import '../models/categoria.dart';
import '../services/database_service.dart';

class CategoriaProvider extends ChangeNotifier {
  List<Categoria> _categorias = [];
  
  List<Categoria> get categorias => _categorias;
  List<Categoria> get categoriasOrdenadas {
    final list = [..._categorias];
    list.sort((a, b) => a.ordem.compareTo(b.ordem));
    return list;
  }
  
  Future<void> carregarCategorias() async {
    _categorias = DatabaseService.categorias;
    notifyListeners();
  }
  
  Future<void> criarCategoria(Categoria categoria) async {
    await DatabaseService.salvarCategoria(categoria);
    await carregarCategorias();
  }
  
  Future<void> atualizarCategoria(Categoria categoria) async {
    await DatabaseService.salvarCategoria(categoria);
    await carregarCategorias();
  }
  
  Future<void> deletarCategoria(String id) async {
    await DatabaseService.deletarCategoria(id);
    await carregarCategorias();
  }
  
  Future<void> reordenarCategorias(int oldIndex, int newIndex) async {
    final list = [..._categorias];
    if (oldIndex < newIndex) newIndex -= 1;
    final item = list.removeAt(oldIndex);
    list.insert(newIndex, item);
    
    for (int i = 0; i < list.length; i++) {
      final categoria = list[i].copyWith(ordem: i);
      await DatabaseService.salvarCategoria(categoria);
    }
    await carregarCategorias();
  }
  
  Categoria? getCategoria(String id) {
  return _categorias.firstWhere((c) => c.id == id, orElse: () => throw Exception('Categoria não encontrada'));
  }
}