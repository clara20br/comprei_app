import 'package:flutter/material.dart';

class DialogConfirmar {
  static Future<bool?> mostrar(
    BuildContext context, {
    required String titulo,
    required String mensagem,
    required String acaoConfirmar,
    bool isDestrutivo = false,
    String? acaoCancelar,
  }) async {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(titulo),
        content: Text(mensagem),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(acaoCancelar ?? 'Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              acaoConfirmar,
              style: TextStyle(
                color: isDestrutivo ? Colors.red : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}