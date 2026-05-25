// lib/main.dart
import 'package:comprou_app/screens/configuracoes_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/database_service.dart';
import 'services/theme_service.dart';
import 'providers/lista_provider.dart';
import 'providers/categoria_provider.dart';
import 'providers/item_provider.dart';
import 'providers/config_provider.dart';
import 'providers/usuario_provider.dart';
import 'screens/home_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/historico_precos_screen.dart';
import 'screens/sobre_screen.dart';
import 'core/themes/theme.dart';
import 'core/constants/enums.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await DatabaseService.init();
  await ThemeService.init();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ListaProvider()..carregarListas()),
        ChangeNotifierProvider(create: (_) => CategoriaProvider()..carregarCategorias()),
        ChangeNotifierProvider(create: (_) => ItemProvider()..carregarItens()),
        ChangeNotifierProvider(create: (_) => ConfigProvider()..carregarConfig()),
        ChangeNotifierProvider(create: (_) => UsuarioProvider()..carregarUsuario()),
      ],
      child: Consumer<ConfigProvider>(
        builder: (context, configProvider, child) {
          final tema = configProvider.config.tema;
          
          ThemeData themeData;
          switch (tema) {
            case TemaApp.claro:
              themeData = AppTheme.lightTheme;
              break;
            case TemaApp.escuro:
              themeData = AppTheme.darkTheme;
              break;
            case TemaApp.sistema:
              themeData = MediaQuery.of(context).platformBrightness == Brightness.dark
                  ? AppTheme.darkTheme
                  : AppTheme.lightTheme;
              break;
          }
          
          return MaterialApp(
            title: 'Comprou?',
            debugShowCheckedModeBanner: false,
            theme: themeData,
            initialRoute: '/',
            routes: {
              '/': (context) => const SplashScreen(),
              '/home': (context) => const HomeScreen(),
              '/historico': (context) => const HistoricoPrecosScreen(),
              '/sobre': (context) => const SobreScreen(),
              '/configuracoes': (context) => const ConfiguracoesScreen(),
            },
          );
        },
      ),
    );
  }
}