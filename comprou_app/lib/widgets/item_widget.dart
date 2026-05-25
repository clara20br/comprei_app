import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../models/item.dart';
import '../providers/item_provider.dart';
import '../core/themes/cores.dart';
import '../core/constants/constants.dart';
import 'modals/dialog_preco.dart';
import 'package:provider/provider.dart';

class ItemWidget extends StatelessWidget {
  final Item item;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onCompradoChanged;

  const ItemWidget({
    super.key,
    required this.item,
    required this.onEdit,
    required this.onDelete,
    required this.onCompradoChanged,
  });

  Future<void> _toggleComprado(BuildContext context) async {
    if (!item.comprado) {
      // Se está marcando como comprado, perguntar o preço
      final preco = await DialogPreco.mostrar(context);
      
      // Atualizar o item no provider
      final itemProvider = context.read<ItemProvider>();
      final itemAtualizado = item.copyWith(
        comprado: true,
        compradoEm: DateTime.now(),
        precoPago: preco,
      );
      await itemProvider.atualizarItem(itemAtualizado);
      onCompradoChanged();
    } else {
      // Se está desmarcando, apenas desmarcar
      final itemProvider = context.read<ItemProvider>();
      final itemAtualizado = item.copyWith(
        comprado: false,
        compradoEm: null,
        precoPago: null,
      );
      await itemProvider.atualizarItem(itemAtualizado);
      onCompradoChanged();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (_) => onEdit(),
            backgroundColor: AppCores.verdeSecundario,
            foregroundColor: Colors.white,
            icon: Icons.edit,
            label: 'Editar',
          ),
          SlidableAction(
            onPressed: (_) => onDelete(),
            backgroundColor: AppCores.vermelhoAlerta,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Remover',
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.all(AppConstants.paddingMedio),
        decoration: BoxDecoration(
          color: item.comprado ? AppCores.verdePastel.withOpacity(0.3) : null,
          border: Border(
            bottom: BorderSide(color: AppCores.cinzaClaro),
          ),
        ),
        child: Row(
          children: [
            // Checkbox de comprado
            Checkbox(
              value: item.comprado,
              onChanged: (_) => _toggleComprado(context),
              activeColor: AppCores.verdePrincipal,
              checkColor: Colors.white,
            ),
            
            // Nome do produto
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.nome,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      decoration: item.comprado
                          ? TextDecoration.lineThrough
                          : null,
                      color: item.comprado ? AppCores.cinzaEscuro : null,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${item.quantidade.toStringAsFixed(item.quantidade == item.quantidade.toInt() ? 0 : 1)} ${item.unidade}',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppCores.cinzaEscuro,
                    ),
                  ),
                ],
              ),
            ),
            
            // Preço pago
            if (item.precoPago != null)
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppCores.verdePrincipal.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'R\$ ${item.precoPago!.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppCores.verdePrincipal,
                    ),
                  ),
                ),
              ),
            
            // Botão de editar
            IconButton(
              icon: Icon(Icons.edit, size: 20, color: AppCores.verdeSecundario),
              onPressed: onEdit,
            ),
          ],
        ),
      ),
    );
  }
}