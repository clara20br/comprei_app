// lib/services/database_service.dart
import 'package:hive_flutter/hive_flutter.dart';
import '../models/lista_compras.dart';
import '../models/categoria.dart';
import '../models/item.dart';
import '../models/historico_preco.dart';
import '../models/configuracao.dart';
import '../models/usuario.dart';
import '../adapters/lista_compras_adapter.dart';
import '../adapters/categoria_adapter.dart';
import '../adapters/item_adapter.dart';
import '../adapters/historico_preco_adapter.dart';
import '../adapters/configuracao_adapter.dart';
import '../adapters/usuario_adapter.dart';

class DatabaseService {
  static late Box<ListaCompras> _listasBox;
  static late Box<Categoria> _categoriasBox;
  static late Box<Item> _itensBox;
  static late Box<HistoricoPreco> _historicoBox;
  static late Box<Configuracao> _configBox;
  static late Box<Usuario> _usuarioBox;
  
  static Future<void> init() async {
    await Hive.initFlutter();
    
    // Registrar adaptadores
    Hive.registerAdapter(ListaComprasAdapter());
    Hive.registerAdapter(CategoriaAdapter());
    Hive.registerAdapter(ItemAdapter());
    Hive.registerAdapter(HistoricoPrecoAdapter());
    Hive.registerAdapter(ConfiguracaoAdapter());
    Hive.registerAdapter(UsuarioAdapter());
    Hive.registerAdapter(PreferenciasUsuarioAdapter());
    Hive.registerAdapter(EstatisticasUsuarioAdapter());
    
    // Abrir boxes
    _listasBox = await Hive.openBox<ListaCompras>('listas');
    _categoriasBox = await Hive.openBox<Categoria>('categorias');
    _itensBox = await Hive.openBox<Item>('itens');
    _historicoBox = await Hive.openBox<HistoricoPreco>('historico');
    _configBox = await Hive.openBox<Configuracao>('configuracoes');
    _usuarioBox = await Hive.openBox<Usuario>('usuarios');
    
    // Configuração padrão
    if (_configBox.isEmpty) {
      await _configBox.put('config', Configuracao());
    }
    
    // Usuário padrão
    if (_usuarioBox.isEmpty) {
      final usuarioPadrao = Usuario.padrao();
      await _usuarioBox.put('usuario_atual', usuarioPadrao);
    }
    
    // Categorias padrão
    if (_categoriasBox.isEmpty) {
      await _criarCategoriasPadrao();
    }
  }
  
  static Future<void> _criarCategoriasPadrao() async {
    final categorias = [
      Categoria(nome: 'Açougue / Carnes', emoji: '🥩', isDefault: true, ordem: 0),
      Categoria(nome: 'Hortifrúti', emoji: '🥬', isDefault: true, ordem: 1),
      Categoria(nome: 'Laticínios e Ovos', emoji: '🥛', isDefault: true, ordem: 2),
      Categoria(nome: 'Cereais, Grãos e Farináceos', emoji: '🌾', isDefault: true, ordem: 3),
      Categoria(nome: 'Bebidas', emoji: '🥤', isDefault: true, ordem: 4),
      Categoria(nome: 'Limpeza', emoji: '🧼', isDefault: true, ordem: 5),
    ];
    
    for (var categoria in categorias) {
      await _categoriasBox.put(categoria.id, categoria);
    }
  }
  
  // ==================== LISTAS ====================
  static List<ListaCompras> get listas => _listasBox.values.toList();
  
  static ListaCompras? getLista(String id) => _listasBox.get(id);
  
  static Future<void> salvarLista(ListaCompras lista) async {
    await _listasBox.put(lista.id, lista);
  }
  
  static Future<void> deletarLista(String id) async {
    await _listasBox.delete(id);
  }
  
  // ==================== CATEGORIAS ====================
  static List<Categoria> get categorias => _categoriasBox.values.toList();
  
  static List<Categoria> get categoriasOrdenadas {
    final list = _categoriasBox.values.toList();
    list.sort((a, b) => a.ordem.compareTo(b.ordem));
    return list;
  }
  
  static Categoria? getCategoria(String id) => _categoriasBox.get(id);
  
  static Future<void> salvarCategoria(Categoria categoria) async {
    await _categoriasBox.put(categoria.id, categoria);
  }
  
  static Future<void> deletarCategoria(String id) async {
    await _categoriasBox.delete(id);
  }
  
  // ==================== ITENS ====================
  static List<Item> get itens => _itensBox.values.toList();
  
  static List<Item> getItensPorCategoria(String categoriaId) {
    return _itensBox.values.where((item) => item.categoriaId == categoriaId).toList();
  }
  
  static List<Item> getItensPorLista(String listaId) {
    return _itensBox.values.where((item) => item.listaId == listaId).toList();
  }
  
  static Future<void> salvarItem(Item item) async {
    await _itensBox.put(item.id, item);
  }
  
  static Future<void> deletarItem(String id) async {
    await _itensBox.delete(id);
  }
  
  // ==================== HISTÓRICO ====================
  static List<HistoricoPreco> get historico => _historicoBox.values.toList();
  
  static Future<void> salvarHistorico(HistoricoPreco historico) async {
    await _historicoBox.put(historico.id, historico);
  }
  
  // ==================== CONFIGURAÇÃO ====================
  static Configuracao get configuracao => _configBox.get('config') ?? Configuracao();
  
  static Future<void> salvarConfiguracao(Configuracao config) async {
    await _configBox.put('config', config);
  }
  
  // ==================== USUÁRIO ====================
  static Future<Usuario?> getUsuarioAtual() async {
    return _usuarioBox.get('usuario_atual');
  }
  
  static Future<void> salvarUsuario(Usuario usuario) async {
    await _usuarioBox.put('usuario_atual', usuario);
  }
  
  // ==================== UTILITÁRIOS ====================
  static Future<void> limparTodosDados() async {
    await _listasBox.clear();
    await _itensBox.clear();
    await _historicoBox.clear();
    
    // Recriar categorias padrão
    await _categoriasBox.clear();
    await _criarCategoriasPadrao();
    
    // Resetar usuário
    final usuarioPadrao = Usuario.padrao();
    await _usuarioBox.put('usuario_atual', usuarioPadrao);
  }
}