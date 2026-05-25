import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../models/categoria.dart';
import '../models/item.dart';
import 'item_widget.dart';
import 'modals/bottom_sheet_editar_item.dart';
import 'modals/dialog_confirmar.dart';
import '../core/themes/cores.dart';
import '../core/constants/constants.dart';

class CategoriaWidget extends StatefulWidget {
  final Categoria categoria;
  final List<Item> itens;
  final String listaId;
  final double totalCategoria;
  final VoidCallback onItemComprado;
  final VoidCallback onItemRemovido;

  const CategoriaWidget({
    super.key,
    required this.categoria,
    required this.itens,
    required this.listaId,
    required this.totalCategoria,
    required this.onItemComprado,
    required this.onItemRemovido,
  });

  @override
  State<CategoriaWidget> createState() => _CategoriaWidgetState();
}

class _CategoriaWidgetState extends State<CategoriaWidget> {
  bool _expandido = true;

  int get _itensPendentes =>
      widget.itens.where((item) => !item.comprado).length;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppConstants.paddingMedio),
      child: Column(
        children: [
          // Header da categoria (clicável)
          InkWell(
            onTap: () => setState(() => _expandido = !_expandido),
            borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedio),
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.paddingMedio),
              child: Row(
                children: [
                  Text(
                    widget.categoria.emoji,
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.categoria.nome,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${_itensPendentes} de ${widget.itens.length} itens',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppCores.cinzaEscuro,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (widget.totalCategoria > 0)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Text(
                        'R\$ ${widget.totalCategoria.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppCores.verdePrincipal,
                        ),
                      ),
                    ),
                  Icon(
                    _expandido
                        ? Icons.expand_less
                        : Icons.expand_more,
                  ),
                ],
              ),
            ),
          ),
          
          // Lista de itens
          if (_expandido && widget.itens.isNotEmpty)
            Column(
              children: [
                const Divider(height: 1),
                ...widget.itens.map((item) => ItemWidget(
                  item: item,
                  onEdit: () => _editarItem(item),
                  onDelete: () => _confirmarRemocao(item),
                  onCompradoChanged: widget.onItemComprado,
                )),
              ],
            ),
          
          // Estado vazio da categoria
          if (_expandido && widget.itens.isEmpty)
            const Padding(
              padding: EdgeInsets.all(AppConstants.paddingMedio),
              child: Text(
                'Nenhum item nesta categoria',
                style: TextStyle(color: AppCores.cinzaEscuro),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _editarItem(Item item) async {
    final itemEditado = await showModalBottomSheet<Item>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => BottomSheetEditarItem(
        item: item,
        categorias: [widget.categoria],
      ),
    );
    
    if (itemEditado != null && mounted) {
      widget.onItemComprado();
    }
  }

  Future<void> _confirmarRemocao(Item item) async {
    final confirmado = await DialogConfirmar.mostrar(
      context,
      titulo: 'Remover item',
      mensagem: 'Deseja remover "${item.nome}" da lista?',
      acaoConfirmar: 'Remover',
      isDestrutivo: true,
    );
    
    if (confirmado == true && mounted) {
      widget.onItemRemovido();
    }
  }
}