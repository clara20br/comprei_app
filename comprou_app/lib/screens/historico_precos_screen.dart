import 'package:flutter/material.dart';
import '../services/preco_service.dart';
import '../models/historico_preco.dart';
import '../core/themes/cores.dart';
import '../core/constants/constants.dart';
import '../widgets/empty_state_widget.dart';

class HistoricoPrecosScreen extends StatefulWidget {
  final String? produtoNome;

  const HistoricoPrecosScreen({super.key, this.produtoNome});

  @override
  State<HistoricoPrecosScreen> createState() => _HistoricoPrecosScreenState();
}

class _HistoricoPrecosScreenState extends State<HistoricoPrecosScreen> {
  Map<String, List<HistoricoPreco>> _historico = {};

  @override
  void initState() {
    super.initState();
    _carregarHistorico();
  }

  void _carregarHistorico() {
    setState(() {
      _historico = PrecoService.getHistoricoAgrupado();
    });
  }

  @override
  Widget build(BuildContext context) {
    final produtos = _historico.keys.toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.produtoNome != null
            ? 'Histórico - ${widget.produtoNome}'
            : 'Histórico de Preços'),
      ),
      body: produtos.isEmpty
          ? EmptyStateWidget(
              icon: Icons.history,
              mensagem: 'Nenhum histórico',
              detalhe: 'Adicione preços aos seus produtos para ver o histórico',
            )
          : ListView.builder(
              padding: const EdgeInsets.all(AppConstants.paddingMedio),
              itemCount: widget.produtoNome != null ? 1 : produtos.length,
              itemBuilder: (context, index) {
                final produto = widget.produtoNome != null
                    ? widget.produtoNome!
                    : produtos[index];
                final historicos = _historico[produto]!;
                
                return Card(
                  margin: const EdgeInsets.only(bottom: AppConstants.paddingMedio),
                  child: ExpansionTile(
                    leading: const Icon(Icons.shopping_bag, color: AppCores.verdePrincipal),
                    title: Text(produto),
                    subtitle: Text(
                      '${historicos.length} registros',
                      style: const TextStyle(fontSize: 12),
                    ),
                    children: historicos.map((h) {
                      return ListTile(
                        title: Text(
                          'R\$ ${h.preco.toStringAsFixed(2)}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text('${h.unidade} • ${_formatarData(h.data)}'),
                        trailing: const Icon(Icons.trending_up, size: 20),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
    );
  }

  String _formatarData(DateTime data) {
    return '${data.day}/${data.month}/${data.year}';
  }
}