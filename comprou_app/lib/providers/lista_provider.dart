import 'package:flutter/material.dart';
import '../models/lista_compras.dart';
import '../services/database_service.dart';

class ListaProvider extends ChangeNotifier {
  List<ListaCompras> _listas = [];
  
  List<ListaCompras> get listas => _listas;
  
  Future<void> carregarListas() async {
    _listas = DatabaseService.listas;
    notifyListeners();
  }
  
  Future<void> criarLista(ListaCompras lista) async {
    await DatabaseService.salvarLista(lista);
    await carregarListas();
  }
  
  Future<void> atualizarLista(ListaCompras lista) async {
    await DatabaseService.salvarLista(lista);
    await carregarListas();
  }
  
  Future<void> deletarLista(String id) async {
    await DatabaseService.deletarLista(id);
    await carregarListas();
  }
  
  ListaCompras? getLista(String id) {
return _listas.firstWhere((l) => l.id == id, orElse: () => throw Exception('Lista não encontrada'));
  }
}