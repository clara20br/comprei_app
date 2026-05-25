import 'package:flutter/material.dart';
import '../core/themes/cores.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.shopping_cart,
              size: 80,
              color: AppCores.verdePrincipal,
            ),
            const SizedBox(height: 24),
            const Text(
              'Comprou?',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 48),
            ElevatedButton.icon(
              onPressed: () {
                // Implementar login com Google depois
                Navigator.pushReplacementNamed(context, '/home');
              },
              icon: const Icon(Icons.login),
              label: const Text('Entrar com Google'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}