import 'package:flutter/material.dart';
import '../../models/categoria.dart';
import '../../models/item.dart';
import '../../core/constants/enums.dart';
import '../../core/constants/unidades.dart';
import '../../core/utils/helpers.dart';

class BottomSheetAdicionarItem extends StatefulWidget {
  final String listaId;
  final List<Categoria> categorias;

  const BottomSheetAdicionarItem({
    super.key,
    required this.listaId,
    required this.categorias,
  });

  @override
  State<BottomSheetAdicionarItem> createState() =>
      _BottomSheetAdicionarItemState();
}

class _BottomSheetAdicionarItemState extends State<BottomSheetAdicionarItem> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _quantidadeController = TextEditingController(text: '1');
  final _unidadeController = TextEditingController(text: 'un');
  final _precoController = TextEditingController();

  Categoria? _categoriaSelecionada;
  bool _incluirPreco = false;

  @override
  void initState() {
    super.initState();
    if (widget.categorias.isNotEmpty) {
      _categoriaSelecionada = widget.categorias.first;
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _quantidadeController.dispose();
    _unidadeController.dispose();
    _precoController.dispose();
    super.dispose();
  }

  Future<void> _selecionarUnidade() async {
    final unidade = await showModalBottomSheet<String>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _BottomSheetUnidades(
        unidadeAtual: _unidadeController.text,
      ),
    );
    if (unidade != null) {
      setState(() {
        _unidadeController.text = unidade;
      });
    }
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
                  'Adicionar Produto',
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
                hintText: 'Ex: Leite, Arroz, Frango...',
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
                  child: GestureDetector(
                    onTap: _selecionarUnidade,
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: _unidadeController,
                        decoration: const InputDecoration(
                          labelText: 'Unidade',
                          suffixIcon: Icon(Icons.arrow_drop_down),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) =>
                            value == null || value.isEmpty ? 'Obrigatório' : null,
                      ),
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
            CheckboxListTile(
              title: const Text('Incluir preço?'),
              value: _incluirPreco,
              onChanged: (value) {
                setState(() {
                  _incluirPreco = value ?? false;
                });
              },
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
            ),
            if (_incluirPreco) ...[
              const SizedBox(height: 8),
              TextFormField(
                controller: _precoController,
                decoration: const InputDecoration(
                  labelText: 'Preço (R\$)',
                  hintText: 'Ex: 10,90',
                  border: OutlineInputBorder(),
                  prefixText: 'R\$ ',
                ),
                keyboardType: TextInputType.number,
              ),
            ],
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
                    child: const Text('Adicionar'),
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
      final item = Item(
        nome: Helpers.capitalizar(_nomeController.text),
        quantidade: double.parse(_quantidadeController.text),
        unidade: _unidadeController.text,
        categoriaId: _categoriaSelecionada!.id,
        listaId: widget.listaId,
        precoPago: _incluirPreco
            ? Helpers.parseDouble(_precoController.text)
            : null,
        comprado: _incluirPreco,
      );
      Navigator.pop(context, item);
    }
  }
}

class _BottomSheetUnidades extends StatelessWidget {
  final String unidadeAtual;

  const _BottomSheetUnidades({required this.unidadeAtual});

  @override
  Widget build(BuildContext context) {
    final unidades = UnidadesHelper.unidadesComuns;
    final outroController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Escolha a unidade',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: unidades.map((unidade) {
              return FilterChip(
                label: Text(unidade),
                selected: unidade == unidadeAtual,
                onSelected: (_) => Navigator.pop(context, unidade),
              );
            }).toList(),
          ),
          const Divider(height: 32),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: outroController,
                  decoration: const InputDecoration(
                    hintText: 'Outra unidade...',
                    border: OutlineInputBorder(),
                  ),
                  autofocus: true,
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  if (outroController.text.isNotEmpty) {
                    Navigator.pop(context, outroController.text);
                  }
                },
                child: const Text('Adicionar'),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}