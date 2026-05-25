library unidades;

import 'enums.dart';

class UnidadesHelper {
  static List<String> get unidadesComuns {
    return [
      'kg', 'g', 'L', 'mL', 'un', 'pacote', 'caixa',
      'dúzia', 'cabeça', 'maço', 'bandeja', 'frasco', 'pote', 'lata',
    ];
  }
  
  static List<TipoUnidade> get unidadesTipo {
    return TipoUnidade.values;
  }
  
  static bool isUnidadePreDefinida(String unidade) {
    return unidadesComuns.contains(unidade);
  }
  
  static String getUnidadeDisplay(String unidade) {
    if (unidade.isEmpty) return 'un';
    return unidade;
  }
  
  static String formatarQuantidade(double quantidade, String unidade) {
    if (quantidade == quantidade.toInt()) {
      return '${quantidade.toInt()} $unidade';
    }
    return '${quantidade.toStringAsFixed(2)} $unidade';
  }
}