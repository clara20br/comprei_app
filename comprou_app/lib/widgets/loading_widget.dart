import 'package:flutter/material.dart';
import '../core/themes/cores.dart';

class LoadingWidget extends StatelessWidget {
  final String? mensagem;

  const LoadingWidget({super.key, this.mensagem});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            color: AppCores.verdePrincipal,
          ),
          if (mensagem != null) ...[
            const SizedBox(height: 16),
            Text(mensagem!),
          ],
        ],
      ),
    );
  }
}