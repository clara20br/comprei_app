import 'package:flutter/material.dart';

class BottomSheetFiltros extends StatefulWidget {
  final bool mostrarComprados;
  final bool mostrarPendentes;
  final Function(bool, bool) onAplicar;

  const BottomSheetFiltros({
    super.key,
    required this.mostrarComprados,
    required this.mostrarPendentes,
    required this.onAplicar,
  });

  @override
  State<BottomSheetFiltros> createState() => _BottomSheetFiltrosState();
}

class _BottomSheetFiltrosState extends State<BottomSheetFiltros> {
  late bool _mostrarComprados;
  late bool _mostrarPendentes;

  @override
  void initState() {
    super.initState();
    _mostrarComprados = widget.mostrarComprados;
    _mostrarPendentes = widget.mostrarPendentes;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Filtros',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          CheckboxListTile(
            title: const Text('Mostrar comprados'),
            value: _mostrarComprados,
            onChanged: (value) {
              setState(() {
                _mostrarComprados = value ?? true;
              });
            },
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
          ),
          CheckboxListTile(
            title: const Text('Mostrar pendentes'),
            value: _mostrarPendentes,
            onChanged: (value) {
              setState(() {
                _mostrarPendentes = value ?? true;
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
                  onPressed: () {
                    setState(() {
                      _mostrarComprados = true;
                      _mostrarPendentes = true;
                    });
                  },
                  child: const Text('Limpar filtros'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    widget.onAplicar(_mostrarComprados, _mostrarPendentes);
                    Navigator.pop(context);
                  },
                  child: const Text('Aplicar'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}