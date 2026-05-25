import 'package:flutter/material.dart';
import '../models/configuracao.dart';
import '../services/database_service.dart';
import '../services/theme_service.dart';
import '../core/constants/enums.dart';

class ConfigProvider extends ChangeNotifier {
  Configuracao _config = Configuracao();
  
  Configuracao get config => _config;
  
  Future<void> carregarConfig() async {
    _config = DatabaseService.configuracao;
    notifyListeners();
  }
  
  Future<void> atualizarTema(TemaApp tema) async {
    _config = _config.copyWith(tema: tema);
    await DatabaseService.salvarConfiguracao(_config);
    await ThemeService.setTheme(tema);
    notifyListeners();
  }
  
  Future<void> atualizarNotificacoes(bool ativar) async {
    _config = _config.copyWith(notificacoes: ativar);
    await DatabaseService.salvarConfiguracao(_config);
    notifyListeners();
  }
  
  Future<void> atualizarBackupAutomatico(bool ativar) async {
    _config = _config.copyWith(backupAutomatico: ativar);
    await DatabaseService.salvarConfiguracao(_config);
    notifyListeners();
  }
  
  Future<void> atualizarUltimoBackup(DateTime data) async {
    _config = _config.copyWith(ultimoBackup: data);
    await DatabaseService.salvarConfiguracao(_config);
    notifyListeners();
  }
}