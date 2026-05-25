import 'package:flutter/material.dart';
import '../../models/categoria.dart';
import '../../models/item.dart';
import '../../core/utils/helpers.dart';

class BottomSheetEditarItem extends StatefulWidget {
  final Item item;
  final List<Categoria> categorias;

  const BottomSheetEditarItem({
    super.key,
    required this.item,
    required this.categorias,
  });

  @override
  State<BottomSheetEditarItem> createState() => _BottomSheetEditarItemState();
}

class _BottomSheetEditarItemState extends State<BottomSheetEditarItem> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nomeController;
  late final TextEditingController _quantidadeController;
  late final TextEditingController _unidadeController;
  late final TextEditingController _precoController;
  late Categoria? _categoriaSelecionada;
  late bool _comprado;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.item.nome);
    _quantidadeController =
        TextEditingController(text: widget.item.quantidade.toString());
    _unidadeController = TextEditingController(text: widget.item.unidade);
    _precoController = TextEditingController(
      text: widget.item.precoPago?.toString() ?? '',
    );
    _categoriaSelecionada = widget.categorias.firstWhere(
      (c) => c.id == widget.item.categoriaId,
      orElse: () => widget.categorias.first,
    );
    _comprado = widget.item.comprado;
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _quantidadeController.dispose();
    _unidadeController.dispose();
    _precoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Editar Produto',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nomeController,
              decoration: const InputDecoration(
                labelText: 'Nome do produto',
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  value == null || value.isEmpty ? 'Campo obrigatório' : null,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _quantidadeController,
                    decoration: const InputDecoration(
                      labelText: 'Quantidade',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Obrigatório';
                      if (double.tryParse(value) == null) return 'Número inválido';
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    controller: _unidadeController,
                    decoration: const InputDecoration(
                      labelText: 'Unidade',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<Categoria>(
              value: _categoriaSelecionada,
              decoration: const InputDecoration(
                labelText: 'Categoria',
                border: OutlineInputBorder(),
              ),
              items: widget.categorias.map((categoria) {
                return DropdownMenuItem(
                  value: categoria,
                  child: Text('${categoria.emoji} ${categoria.nome}'),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _categoriaSelecionada = value;
                });
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _precoController,
              decoration: const InputDecoration(
                labelText: 'Preço pago (R\$)',
                hintText: 'Opcional',
                border: OutlineInputBorder(),
                prefixText: 'R\$ ',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            CheckboxListTile(
              title: const Text('Produto comprado'),
              value: _comprado,
              onChanged: (value) {
                setState(() {
                  _comprado = value ?? false;
                });
              },
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancelar'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _salvar,
                    child: const Text('Salvar'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _salvar() {
    if (_formKey.currentState!.validate()) {
      final itemAtualizado = widget.item.copyWith(
        nome: Helpers.capitalizar(_nomeController.text),
        quantidade: double.parse(_quantidadeController.text),
        unidade: _unidadeController.text,
        categoriaId: _categoriaSelecionada!.id,
        precoPago: _precoController.text.isNotEmpty
            ? Helpers.parseDouble(_precoController.text)
            : null,
        comprado: _comprado,
        compradoEm: _comprado ? DateTime.now() : null,
      );
      Navigator.pop(context, itemAtualizado);
    }
  }
}