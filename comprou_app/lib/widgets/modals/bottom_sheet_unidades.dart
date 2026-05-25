import 'package:flutter/material.dart';
import '../../core/constants/unidades.dart';
import '../../core/themes/cores.dart';

class BottomSheetUnidades extends StatefulWidget {
  final String unidadeAtual;
  final Function(String) onUnidadeSelecionada;

  const BottomSheetUnidades({
    super.key,
    required this.unidadeAtual,
    required this.onUnidadeSelecionada,
  });

  @override
  State<BottomSheetUnidades> createState() => _BottomSheetUnidadesState();
}

class _BottomSheetUnidadesState extends State<BottomSheetUnidades> {
  final TextEditingController _outroController = TextEditingController();
  String _unidadePersonalizada = '';

  @override
  void dispose() {
    _outroController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final unidades = UnidadesHelper.unidadesComuns;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cabeçalho
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Escolha a unidade',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Lista de unidades pré-definidas
          const Text(
            'Unidades comuns:',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: unidades.map((unidade) {
              final isSelected = unidade == widget.unidadeAtual;
              return FilterChip(
                label: Text(unidade),
                selected: isSelected,
                selectedColor: AppCores.verdePastel,
                onSelected: (_) {
                  widget.onUnidadeSelecionada(unidade);
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
          
          const Divider(height: 32),
          
          // Campo para unidade personalizada
          const Text(
            'Ou digite uma unidade personalizada:',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _outroController,
                  decoration: const InputDecoration(
                    hintText: 'Ex: bandeja, dúzia, cabeça...',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                  ),
                  onChanged: (value) {
                    _unidadePersonalizada = value;
                  },
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  if (_outroController.text.trim().isNotEmpty) {
                    widget.onUnidadeSelecionada(_outroController.text.trim());
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppCores.verdePrincipal,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text('Adicionar'),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Dica
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppCores.verdePastel.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, size: 20, color: AppCores.verdePrincipal),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Dica: Você pode usar qualquer unidade como kg, g, L, mL, un, pacote, caixa, dúzia, bandeja, etc.',
                    style: TextStyle(fontSize: 12, color: AppCores.verdeEscuro),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}