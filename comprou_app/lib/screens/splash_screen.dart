import 'package:flutter/material.dart';
import '../core/constants/constants.dart';
import '../core/themes/cores.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  Future<void> _navigateToHome() async {
    await Future.delayed(AppConstants.duracaoSplash);
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppCores.verdeEscuro,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppCores.branco,
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Icon(
                Icons.shopping_cart,
                size: 70,
                color: AppCores.verdePrincipal,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Comprou?',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppCores.branco,
              ),
            ),
            const SizedBox(height: 48),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppCores.branco),
            ),
          ],
        ),
      ),
    );
  }
}