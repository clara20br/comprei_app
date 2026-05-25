import '../models/historico_preco.dart';
import '../models/item.dart';
import 'database_service.dart';

class PrecoService {
  static Future<void> salvarPrecoItem(Item item) async {
    if (item.precoPago == null) return;
    
    final historico = HistoricoPreco(
      produtoNome: item.nome,
      preco: item.precoPago!,
      unidade: item.unidade,
      data: item.compradoEm ?? DateTime.now(),
      listaId: item.listaId,
    );
    
    await DatabaseService.salvarHistorico(historico);
  }
  
  static List<HistoricoPreco> getHistoricoPorProduto(String produtoNome) {
    return DatabaseService.historico
        .where((h) => h.produtoNome == produtoNome)
        .toList()
      ..sort((a, b) => b.data.compareTo(a.data));
  }
  
  static double? getUltimoPreco(String produtoNome) {
    final historico = getHistoricoPorProduto(produtoNome);
    if (historico.isEmpty) return null;
    return historico.first.preco;
  }
  
  static Map<String, List<HistoricoPreco>> getHistoricoAgrupado() {
    final Map<String, List<HistoricoPreco>> agrupado = {};
    for (var item in DatabaseService.historico) {
      agrupado.putIfAbsent(item.produtoNome, () => []).add(item);
    }
    return agrupado;
  }
}