import 'package:flutter/material.dart';
import '../core/themes/cores.dart';
import '../core/constants/constants.dart';

class EmptyStateWidget extends StatelessWidget {
  final IconData icon;
  final String mensagem;
  final String? detalhe;
  final VoidCallback? onAction;
  final String? actionLabel;

  const EmptyStateWidget({
    super.key,
    required this.icon,
    required this.mensagem,
    this.detalhe,
    this.onAction,
    this.actionLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 80,
            color: AppCores.cinzaClaro,
          ),
          const SizedBox(height: AppConstants.paddingMedio),
          Text(
            mensagem,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (detalhe != null) ...[
            const SizedBox(height: 8),
            Text(
              detalhe!,
              style: TextStyle(
                color: AppCores.cinzaEscuro,
              ),
            ),
          ],
          if (onAction != null && actionLabel != null) ...[
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onAction,
              child: Text(actionLabel!),
            ),
          ],
        ],
      ),
    );
  }
}