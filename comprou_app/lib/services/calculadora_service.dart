import 'package:math_expressions/math_expressions.dart';

class CalculadoraService {
  static String avaliarExpressao(String expressao) {
    try {
      if (expressao.isEmpty) return '0';
      
      // Trocar vírgulas por pontos
      expressao = expressao.replaceAll(',', '.');
      
      // Verificar se é uma expressão válida
      final regExp = RegExp(r'^[0-9+\-*/%.]+$');
      if (!regExp.hasMatch(expressao)) {
        return 'Erro';
      }
      
      final parser = Parser();
      final expression = parser.parse(expressao);
      final contextModel = ContextModel();
      final result = expression.evaluate(EvaluationType.REAL, contextModel);
      
      if (result == result.toInt()) {
        return result.toInt().toString();
      }
      return result.toStringAsFixed(2);
    } catch (e) {
      return 'Erro';
    }
  }
  
  static String formatarParaMoeda(String valor) {
    try {
      final doubleValue = double.tryParse(valor.replaceAll(',', '.'));
      if (doubleValue == null) return 'R\$ 0,00';
      
      final formatado = doubleValue.toStringAsFixed(2);
      final partes = formatado.split('.');
      return 'R\$ ${partes[0]},${partes[1]}';
    } catch (e) {
      return 'R\$ 0,00';
    }
  }
}