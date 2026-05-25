import 'package:flutter/material.dart';
import '../core/themes/cores.dart';
import '../core/constants/constants.dart';

class SobreScreen extends StatelessWidget {
  const SobreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sobre'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.paddingGrande),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppCores.verdePrincipal,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: const Icon(
                  Icons.shopping_cart,
                  size: 50,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Comprou?',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Versão 1.0.0',
                style: TextStyle(
                  color: AppCores.cinzaEscuro,
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Um aplicativo de lista de supermercado '
                'com categorias, quantidades personalizadas '
                'e histórico de preços.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 48),
              const Text(
                'Desenvolvido com Flutter',
                style: TextStyle(
                  fontSize: 12,
                  color: AppCores.cinzaEscuro,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}