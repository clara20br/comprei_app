import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/categoria_provider.dart';
import '../models/categoria.dart';
import '../core/themes/cores.dart';
import '../widgets/modals/bottom_sheet_adicionar_categoria.dart';
import '../widgets/modals/dialog_confirmar.dart';
import '../core/constants/constants.dart';

class GerenciarCategoriasScreen extends StatefulWidget {
  const GerenciarCategoriasScreen({super.key});

  @override
  State<GerenciarCategoriasScreen> createState() => _GerenciarCategoriasScreenState();
}

class _GerenciarCategoriasScreenState extends State<GerenciarCategoriasScreen> {
  @override
  Widget build(BuildContext context) {
    final categoriaProvider = context.watch<CategoriaProvider>();
    final categorias = categoriaProvider.categoriasOrdenadas;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciar Categorias'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _adicionarCategoria,
          ),
        ],
      ),
      body: ReorderableListView(
        padding: const EdgeInsets.all(AppConstants.paddingMedio),
        onReorder: (oldIndex, newIndex) {
          categoriaProvider.reordenarCategorias(oldIndex, newIndex);
        },
        children: categorias.map((categoria) {
          return Card(
            key: Key(categoria.id),
            margin: const EdgeInsets.only(bottom: AppConstants.paddingMedio),
            child: ListTile(
              leading: Text(categoria.emoji, style: const TextStyle(fontSize: 28)),
              title: Text(categoria.nome),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: AppCores.verdeSecundario),
                    onPressed: () => _editarCategoria(categoria),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: AppCores.vermelhoAlerta),
                    onPressed: () => _excluirCategoria(categoria),
                  ),
                  const Icon(Icons.drag_handle, color: Colors.grey),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Future<void> _adicionarCategoria() async {
    final novaCategoria = await showModalBottomSheet<Categoria>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const BottomSheetAdicionarCategoria(),
    );
    
    if (novaCategoria != null && mounted) {
      await context.read<CategoriaProvider>().criarCategoria(novaCategoria);
    }
  }

  void _editarCategoria(Categoria categoria) {
    // TODO: Implementar edição de categoria
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Edição em desenvolvimento')),
    );
  }

  Future<void> _excluirCategoria(Categoria categoria) async {
    final confirmado = await DialogConfirmar.mostrar(
      context,
      titulo: 'Excluir categoria',
      mensagem: 'Deseja excluir "${categoria.nome}"?',
      acaoConfirmar: 'Excluir',
      isDestrutivo: true,
    );
    
    if (confirmado == true && mounted) {
      await context.read<CategoriaProvider>().deletarCategoria(categoria.id);
    }
  }
}