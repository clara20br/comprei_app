import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import '../core/themes/cores.dart';

class CalculadoraScreen extends StatefulWidget {
  final Function(double)? onResultadoSelecionado;

  const CalculadoraScreen({super.key, this.onResultadoSelecionado});

  @override
  State<CalculadoraScreen> createState() => _CalculadoraScreenState();
}

class _CalculadoraScreenState extends State<CalculadoraScreen> {
  String _expressao = '';
  String _resultado = '0';
  String _ultimoResultado = '';
  List<String> _historico = [];
  bool _novaEntrada = true;

  void _adicionarCaracter(String caracter) {
    setState(() {
      if (_novaEntrada) {
        _expressao = '';
        _novaEntrada = false;
      }
      
      switch (caracter) {
        case 'AC':
          _expressao = '';
          _resultado = '0';
          _novaEntrada = true;
          break;
        case 'C':
          if (_expressao.isNotEmpty) {
            _expressao = _expressao.substring(0, _expressao.length - 1);
          }
          break;
        case '=':
          _calcular();
          break;
        default:
          _expressao += caracter;
      }
    });
  }

  void _calcular() {
    try {
      String expressao = _expressao
          .replaceAll('×', '*')
          .replaceAll('÷', '/')
          .replaceAll('%', '/100');
          
      Parser parser = Parser();
      Expression exp = parser.parse(expressao);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);
      
      String resultadoFormatado;
      if (eval == eval.toInt()) {
        resultadoFormatado = eval.toInt().toString();
      } else {
        resultadoFormatado = eval.toStringAsFixed(2);
      }
      
      setState(() {
        _resultado = resultadoFormatado;
        _ultimoResultado = resultadoFormatado;
        _novaEntrada = true;
        
        // Adicionar ao histórico
        _historico.insert(0, '$_expressao = $_resultado');
        if (_historico.length > 10) _historico.removeLast();
      });
    } catch (e) {
      setState(() {
        _resultado = 'Erro';
        _novaEntrada = true;
      });
    }
  }

  void _usarResultado() {
    final doubleResultado = double.tryParse(_resultado);
    if (doubleResultado != null && widget.onResultadoSelecionado != null) {
      widget.onResultadoSelecionado!(doubleResultado);
      Navigator.pop(context);
    } else if (doubleResultado != null) {
      Navigator.pop(context, doubleResultado.toString());
    }
  }

  void _limparHistorico() {
    setState(() {
      _historico.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppCores.cinzaEscuro,
      appBar: AppBar(
        title: const Text(
          'Calculadora',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppCores.verdePrincipal,
        foregroundColor: AppCores.branco,
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => _mostrarHistorico(),
            tooltip: 'Histórico',
          ),
          TextButton(
            onPressed: _usarResultado,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'USAR',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Display principal
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppCores.cinzaEscuro,
                  AppCores.cinzaEscuro.withValues(alpha: 0.9),
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Expressão
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    reverse: true,
                    child: Text(
                      _expressao.isEmpty ? '0' : _expressao,
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white.withValues(alpha: 0.6),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // Resultado
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (_ultimoResultado.isNotEmpty && _expressao.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppCores.verdePrincipal.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.check, size: 14, color: AppCores.verdeClaro),
                            const SizedBox(width: 4),
                            Text(
                              'Último: $_ultimoResultado',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppCores.verdeClaro,
                              ),
                            ),
                          ],
                        ),
                      ),
                    Expanded(
                      child: Text(
                        _resultado,
                        textAlign: TextAlign.end,
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Botões da calculadora
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  // Linha 1: AC, C, %, /
                  Expanded(
                    child: Row(
                      children: [
                        _buildBotao('AC', AppCores.vermelhoAlerta, grande: true),
                        _buildBotao('C', Colors.orange),
                        _buildBotao('%', Colors.orange),
                        _buildBotao('÷', AppCores.verdePrincipal),
                      ],
                    ),
                  ),
                  // Linha 2: 7, 8, 9, ×
                  Expanded(
                    child: Row(
                      children: [
                        _buildBotao('7', AppCores.cinzaMedio),
                        _buildBotao('8', AppCores.cinzaMedio),
                        _buildBotao('9', AppCores.cinzaMedio),
                        _buildBotao('×', AppCores.verdePrincipal),
                      ],
                    ),
                  ),
                  // Linha 3: 4, 5, 6, -
                  Expanded(
                    child: Row(
                      children: [
                        _buildBotao('4', AppCores.cinzaMedio),
                        _buildBotao('5', AppCores.cinzaMedio),
                        _buildBotao('6', AppCores.cinzaMedio),
                        _buildBotao('-', AppCores.verdePrincipal),
                      ],
                    ),
                  ),
                  // Linha 4: 1, 2, 3, +
                  Expanded(
                    child: Row(
                      children: [
                        _buildBotao('1', AppCores.cinzaMedio),
                        _buildBotao('2', AppCores.cinzaMedio),
                        _buildBotao('3', AppCores.cinzaMedio),
                        _buildBotao('+', AppCores.verdePrincipal),
                      ],
                    ),
                  ),
                  // Linha 5: 0, 00, ., =
                  Expanded(
                    child: Row(
                      children: [
                        _buildBotao('0', AppCores.cinzaMedio, grande: true),
                        _buildBotao('00', AppCores.cinzaMedio),
                        _buildBotao('.', AppCores.cinzaMedio),
                        _buildBotao('=', AppCores.verdePrincipal, grande: true),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Dica de uso
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.tips_and_updates, size: 16, color: AppCores.verdeClaro),
                const SizedBox(width: 8),
                Text(
                  'Dica: Use o botão USAR para aplicar o resultado',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBotao(String texto, Color cor, {bool grande = false}) {
    return Expanded(
      flex: grande ? 2 : 1,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Material(
          elevation: 2,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            onTap: () => _adicionarCaracter(texto),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    cor,
                    cor.withValues(alpha: 0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(
                  texto,
                  style: TextStyle(
                    fontSize: grande ? 28 : 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _mostrarHistorico() {
    if (_historico.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nenhum cálculo no histórico'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        height: 400,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Histórico',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: _limparHistorico,
                  child: const Text(
                    'Limpar',
                    style: TextStyle(color: AppCores.vermelhoAlerta),
                  ),
                ),
              ],
            ),
            const Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: _historico.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const Icon(Icons.calculate, color: AppCores.verdePrincipal),
                    title: Text(_historico[index]),
                    trailing: IconButton(
                      icon: const Icon(Icons.copy, size: 18),
                      onPressed: () {
                        final resultado = _historico[index].split('=').last.trim();
                        Navigator.pop(context);
                        _resultado = resultado;
                        _usarResultado();
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}