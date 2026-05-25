library constants;

class AppConstants {
  static const String appName = 'Comprou?';
  static const String databaseName = 'comprou_database';
  
  static const String keyTema = 'tema_app';
  static const String keyPrimeiraVez = 'primeira_vez';
  static const String keyUltimoBackup = 'ultimo_backup';
  
  static const Duration duracaoSplash = Duration(seconds: 2);
  static const Duration duracaoSnackbar = Duration(seconds: 3);
  
  static const double borderRadiusPequeno = 8.0;
  static const double borderRadiusMedio = 12.0;
  static const double borderRadiusGrande = 28.0;
  static const double paddingPequeno = 8.0;
  static const double paddingMedio = 16.0;
  static const double paddingGrande = 24.0;
  
  static const int maxItensPorLista = 200;
  static const int maxCategorias = 50;
  static const int maxHistoricoPrecos = 100;
  
  static const String regexEmail = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
}