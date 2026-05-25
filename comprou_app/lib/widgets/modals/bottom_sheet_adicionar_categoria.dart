import 'package:flutter/material.dart';
import '../../models/categoria.dart';
import '../../core/themes/cores.dart';
import '../../core/utils/helpers.dart';
import '../../providers/categoria_provider.dart';
import 'package:provider/provider.dart';

class BottomSheetAdicionarCategoria extends StatefulWidget {
  const BottomSheetAdicionarCategoria({super.key});

  @override
  State<BottomSheetAdicionarCategoria> createState() =>
      _BottomSheetAdicionarCategoriaState();
}

class _BottomSheetAdicionarCategoriaState
    extends State<BottomSheetAdicionarCategoria> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  String _emojiSelecionado = '🛒';
  Color _corSelecionada = AppCores.verdePastel;

  final List<String> _emojis = [
    '🥩', '🥬', '🥛', '🌾', '🥤', '🧼', '🍞', '🍎', '🐟', '🥚', '🧀', '🍪', '☕', '🍺', '🧴', '🧽', '🛒'
  ];

  final List<Color> _cores = [
    AppCores.verdePastel,
    AppCores.categoriaAcougue,
    AppCores.categoriaHortifruti,
    AppCores.categoriaLaticinios,
    AppCores.categoriaCereais,
    AppCores.categoriaBebidas,
    AppCores.categoriaLimpeza,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.indigo,
  ];

  @override
  void dispose() {
    _nomeController.dispose();
    super.dispose();
  }

  Future<void> _criarCategoria() async {
    if (_formKey.currentState!.validate()) {
      final novaCategoria = Categoria(
        nome: Helpers.capitalizar(_nomeController.text),
        emoji: _emojiSelecionado,
        cor: _corSelecionada,
      );
      
      // Salvar no provider
      await context.read<CategoriaProvider>().criarCategoria(novaCategoria);
      
      if (mounted) {
        Navigator.pop(context, novaCategoria);
      }
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
                  'Nova Categoria',
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
                labelText: 'Nome da categoria',
                hintText: 'Ex: Padaria, Peixaria...',
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  value == null || value.isEmpty ? 'Campo obrigatório' : null,
            ),
            const SizedBox(height: 16),
            const Text(
              'Escolha um emoji:',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: _emojis.map((emoji) {
                return FilterChip(
                  label: Text(emoji, style: const TextStyle(fontSize: 24)),
                  selected: _emojiSelecionado == emoji,
                  onSelected: (_) {
                    setState(() {
                      _emojiSelecionado = emoji;
                    });
                  },
                  selectedColor: AppCores.verdePastel,
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            const Text(
              'Escolha uma cor:',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: _cores.map((cor) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _corSelecionada = cor;
                    });
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: cor,
                      shape: BoxShape.circle,
                      border: _corSelecionada == cor
                          ? Border.all(color: Colors.black, width: 3)
                          : null,
                    ),
                  ),
                );
              }).toList(),
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
                    onPressed: _criarCategoria,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppCores.verdePrincipal,
                    ),
                    child: const Text('Criar'),
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
}