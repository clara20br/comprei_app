import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/categoria_provider.dart';
import '../providers/item_provider.dart';
import '../providers/lista_provider.dart';
import '../models/categoria.dart';
import '../models/item.dart';
import '../widgets/modals/bottom_sheet_adicionar_item.dart';
import '../widgets/modals/dialog_confirmar.dart';
import '../core/themes/cores.dart';
import 'calculadora_screen.dart';

class ListaDetalheScreen extends StatefulWidget {
  final String listaId;

  const ListaDetalheScreen({super.key, required this.listaId});

  @override
  State<ListaDetalheScreen> createState() => _ListaDetalheScreenState();
}

class _ListaDetalheScreenState extends State<ListaDetalheScreen> {
  String _filtroBusca = '';

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    await context.read<ItemProvider>().carregarItens();
    if (mounted) setState(() {});
  }

  Future<void> _limparTudo() async {
    final confirmado = await DialogConfirmar.mostrar(
      context,
      titulo: 'Limpar tudo?',
      mensagem: 'Isso vai remover TODOS os itens da lista.',
      acaoConfirmar: 'Limpar',
      isDestrutivo: true,
    );

    if (confirmado == true && mounted) {
      final itens = context.read<ItemProvider>().getItensPorLista(widget.listaId);
      for (var item in itens) {
        await context.read<ItemProvider>().deletarItem(item.id);
      }
      if (mounted) _carregarDados();
    }
  }

  Future<void> _abrirCalculadora({Item? item}) async {
    final resultado = await Navigator.push<double>(
      context,
      MaterialPageRoute(
        builder: (_) => CalculadoraScreen(
          onResultadoSelecionado: (valor) {
            if (item != null) {
              _atualizarPrecoItem(item, valor);
            }
          },
        ),
      ),
    );
    
    if (resultado != null && mounted) {
      if (item == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Resultado: R\$ ${resultado.toStringAsFixed(2)}'),
            backgroundColor: AppCores.verdePrincipal,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  Future<void> _atualizarPrecoItem(Item item, double preco) async {
    final itemProvider = context.read<ItemProvider>();
    final itemAtualizado = item.copyWith(
      precoPago: preco,
      comprado: true,
      compradoEm: DateTime.now(),
    );
    await itemProvider.atualizarItem(itemAtualizado);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Preço de R\$ ${preco.toStringAsFixed(2)} adicionado a "${item.nome}"!'),
          backgroundColor: AppCores.verdePrincipal,
        ),
      );
      _carregarDados();
    }
  }

  Future<void> _adicionarItem() async {
    final categorias = context.read<CategoriaProvider>().categorias;
    if (categorias.isEmpty) return;
    
    final novoItem = await showModalBottomSheet<Item>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => BottomSheetAdicionarItem(
        listaId: widget.listaId,
        categorias: categorias,
      ),
    );
    
    if (novoItem != null && mounted) {
      await context.read<ItemProvider>().criarItem(novoItem);
      if (mounted) _carregarDados();
    }
  }

  Future<void> _toggleItemComprado(Item item) async {
    final itemProvider = context.read<ItemProvider>();
    final itemAtualizado = item.copyWith(
      comprado: !item.comprado,
      compradoEm: !item.comprado ? DateTime.now() : null,
    );
    await itemProvider.atualizarItem(itemAtualizado);
    _carregarDados();
  }

  Future<void> _removerItem(Item item) async {
    final confirmado = await DialogConfirmar.mostrar(
      context,
      titulo: 'Remover item',
      mensagem: 'Deseja remover "${item.nome}"?',
      acaoConfirmar: 'Remover',
      isDestrutivo: true,
    );
    
    if (confirmado == true && mounted) {
      await context.read<ItemProvider>().deletarItem(item.id);
      _carregarDados();
    }
  }

  void _aumentarQuantidade(Item item) async {
    final itemProvider = context.read<ItemProvider>();
    double incremento = 0.5;
    if (item.unidade == 'un' || item.unidade == 'L') {
      incremento = 1;
    }
    final itemAtualizado = item.copyWith(
      quantidade: item.quantidade + incremento,
    );
    await itemProvider.atualizarItem(itemAtualizado);
    _carregarDados();
  }

  void _diminuirQuantidade(Item item) async {
    if (item.quantidade <= 0) return;
    final itemProvider = context.read<ItemProvider>();
    double decremento = 0.5;
    if (item.unidade == 'un' || item.unidade == 'L') {
      decremento = 1;
    }
    final novaQuantidade = item.quantidade - decremento;
    if (novaQuantidade >= 0) {
      final itemAtualizado = item.copyWith(quantidade: novaQuantidade);
      await itemProvider.atualizarItem(itemAtualizado);
      _carregarDados();
    }
  }

  @override
  Widget build(BuildContext context) {
    final listaProvider = context.watch<ListaProvider>();
    final categoriaProvider = context.watch<CategoriaProvider>();
    final itemProvider = context.watch<ItemProvider>();
    
    final lista = listaProvider.getLista(widget.listaId);
    final categorias = categoriaProvider.categoriasOrdenadas;
    final todosItens = itemProvider.getItensPorLista(widget.listaId);
    
    if (lista == null) {
      return const Scaffold(
        body: Center(child: Text('Lista não encontrada')),
      );
    }
    
    List<Item> itensFiltrados = todosItens;
    if (_filtroBusca.isNotEmpty) {
      itensFiltrados = todosItens
          .where((item) => item.nome
              .toLowerCase()
              .contains(_filtroBusca.toLowerCase()))
          .toList();
    }
    
    final Map<String, List<Item>> itensPorCategoria = {};
    for (var categoria in categorias) {
      itensPorCategoria[categoria.id] = [];
    }
    for (var item in itensFiltrados) {
      if (itensPorCategoria.containsKey(item.categoriaId)) {
        itensPorCategoria[item.categoriaId]!.add(item);
      }
    }
    
    final totalItens = todosItens.length;
    final totalComprados = todosItens.where((i) => i.comprado).length;
    final totalGasto = itemProvider.getTotalPorLista(widget.listaId);
    
    return Scaffold(
      backgroundColor: AppCores.cinzaClaro,
      appBar: AppBar(
        title: Text(lista.nome),
        backgroundColor: AppCores.verdePrincipal,
        foregroundColor: AppCores.branco,
        actions: [
          IconButton(
            icon: const Icon(Icons.calculate),
            onPressed: () => _abrirCalculadora(),
            tooltip: 'Calculadora',
          ),
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: _limparTudo,
            tooltip: 'Limpar tudo',
          ),
        ],
      ),
      body: Column(
        children: [
          // Barra de busca
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              decoration: BoxDecoration(
                color: AppCores.branco,
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Buscar item...',
                  prefixIcon: Icon(Icons.search, color: AppCores.cinzaMedio),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onChanged: (value) {
                  setState(() {
                    _filtroBusca = value;
                  });
                },
              ),
            ),
          ),
          
          // Estatísticas
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _buildStatChip(
                  icon: Icons.shopping_cart,
                  label: '$totalItens itens',
                  color: AppCores.verdePrincipal,
                ),
                const SizedBox(width: 8),
                _buildStatChip(
                  icon: Icons.check_circle,
                  label: '$totalComprados comprados',
                  color: AppCores.verdeClaro,
                ),
                const SizedBox(width: 8),
                _buildStatChip(
                  icon: Icons.attach_money,
                  label: 'R\$ ${totalGasto.toStringAsFixed(2)}',
                  color: AppCores.amareloDestaque,
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Lista de categorias
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: categorias.length,
              itemBuilder: (context, index) {
                final categoria = categorias[index];
                final itens = itensPorCategoria[categoria.id] ?? [];
                
                if (itens.isEmpty && _filtroBusca.isNotEmpty) {
                  return const SizedBox.shrink();
                }
                
                return _buildCategoriaSection(categoria, itens);
              },
            ),
          ),
          
          // Botões de ação
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppCores.branco,
              boxShadow: [
                BoxShadow(
                  color: AppCores.cinzaMedio.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _adicionarItem,
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Adicionar item'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppCores.verdePrincipal,
                      foregroundColor: AppCores.branco,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _limparTudo,
                    icon: const Icon(Icons.delete_sweep, size: 18),
                    label: const Text('Limpar tudo'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppCores.vermelhoAlerta,
                      side: const BorderSide(color: AppCores.vermelhoAlerta),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriaSection(Categoria categoria, List<Item> itens) {
    if (itens.isEmpty) {
      return const SizedBox.shrink();
    }
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ExpansionTile(
        initiallyExpanded: true,
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        childrenPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Row(
          children: [
            Text(categoria.emoji, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 12),
            Text(
              categoria.nome,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        children: itens.map((item) => _buildItemRow(item)).toList(),
      ),
    );
  }

  Widget _buildItemRow(Item item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: item.comprado ? AppCores.verdePastel : AppCores.branco,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Checkbox de comprado
          GestureDetector(
            onTap: () => _toggleItemComprado(item),
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: item.comprado ? AppCores.verdePrincipal : Colors.transparent,
                border: Border.all(
                  color: item.comprado ? AppCores.verdePrincipal : AppCores.cinzaMedio,
                  width: 2,
                ),
              ),
              child: item.comprado
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : null,
            ),
          ),
          const SizedBox(width: 12),
          
          // Nome do item e preço
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.nome,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    decoration: item.comprado ? TextDecoration.lineThrough : null,
                    color: item.comprado ? AppCores.cinzaMedio : AppCores.cinzaEscuro,
                  ),
                ),
                if (item.precoPago != null)
                  Text(
                    'R\$ ${item.precoPago!.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppCores.verdePrincipal,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ),
          
          // Controles de quantidade
          Container(
            decoration: BoxDecoration(
              color: AppCores.cinzaClaro,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.remove, size: 16, color: AppCores.cinzaEscuro),
                  onPressed: () => _diminuirQuantidade(item),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 28),
                ),
                Text(
                  '${item.quantidade.toStringAsFixed(item.quantidade == item.quantidade.toInt() ? 0 : 1)} ${item.unidade}',
                  style: const TextStyle(fontSize: 12),
                ),
                IconButton(
                  icon: Icon(Icons.add, size: 16, color: AppCores.cinzaEscuro),
                  onPressed: () => _aumentarQuantidade(item),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 28),
                ),
              ],
            ),
          ),
          
          const SizedBox(width: 8),
          
          // Botão da calculadora (para adicionar preço)
          GestureDetector(
            onTap: () => _abrirCalculadora(item: item),
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: AppCores.verdePrincipal.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.calculate, size: 16, color: AppCores.verdePrincipal),
            ),
          ),
          
          const SizedBox(width: 4),
          
          // Botão remover
          GestureDetector(
            onTap: () => _removerItem(item),
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: AppCores.vermelhoAlerta.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.close, size: 16, color: AppCores.vermelhoAlerta),
            ),
          ),
        ],
      ),
    );
  }
}