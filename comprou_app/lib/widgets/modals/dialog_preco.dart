import 'package:flutter/material.dart';

class DialogPreco {
  static Future<double?> mostrar(BuildContext context) async {
    final controller = TextEditingController();
    
    return showDialog<double>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Adicionar preço'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Deseja adicionar o preço pago?'),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'Preço (R\$)',
                prefixText: 'R\$ ',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              autofocus: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, null),
            child: const Text('Não'),
          ),
          TextButton(
            onPressed: () {
              final preco = double.tryParse(controller.text.replaceAll(',', '.'));
              Navigator.pop(context, preco);
            },
            child: const Text('Sim'),
          ),
        ],
      ),
    );
  }
}