// lib/providers/usuario_provider.dart
import 'package:flutter/material.dart';
import '../models/usuario.dart';
import '../services/database_service.dart';
import '../services/storage_service.dart';
import 'dart:io';

class UsuarioProvider extends ChangeNotifier {
  Usuario? _usuarioAtual;
  
  Usuario? get usuarioAtual => _usuarioAtual;
  bool get hasUsuario => _usuarioAtual != null;
  
  Future<void> carregarUsuario() async {
    _usuarioAtual = await DatabaseService.getUsuarioAtual();
    
    if (_usuarioAtual == null) {
      _usuarioAtual = Usuario.padrao();
      await DatabaseService.salvarUsuario(_usuarioAtual!);
    }
    
    notifyListeners();
  }
  
  Future<void> atualizarPerfil({
    String? nome,
    String? email,
    File? foto,
  }) async {
    if (_usuarioAtual == null) return;
    
    String? novoFotoPath = _usuarioAtual!.fotoPath;
    
    if (foto != null) {
      if (_usuarioAtual!.fotoPath != null) {
        await StorageService.deletarFotoPerfil(_usuarioAtual!.fotoPath!);
      }
      
      novoFotoPath = await StorageService.salvarFotoPerfil(foto);
    }
    
    _usuarioAtual = _usuarioAtual!.copyWith(
      nome: nome ?? _usuarioAtual!.nome,
      email: email ?? _usuarioAtual!.email,
      fotoPath: novoFotoPath,
      ultimoAcesso: DateTime.now(),
    );
    
    await DatabaseService.salvarUsuario(_usuarioAtual!);
    notifyListeners();
  }
  
  Future<void> removerFoto() async {
    if (_usuarioAtual == null || _usuarioAtual!.fotoPath == null) return;
    
    await StorageService.deletarFotoPerfil(_usuarioAtual!.fotoPath!);
    
    _usuarioAtual = _usuarioAtual!.copyWith(fotoPath: null);
    await DatabaseService.salvarUsuario(_usuarioAtual!);
    notifyListeners();
  }
  
  Future<void> registrarAcesso() async {
    if (_usuarioAtual == null) return;
    
    _usuarioAtual = _usuarioAtual!.copyWith(
      ultimoAcesso: DateTime.now(),
    );
    
    await DatabaseService.salvarUsuario(_usuarioAtual!);
    notifyListeners();
  }
  // lib/providers/usuario_provider.dart
// Adicionar este método na classe UsuarioProvider

Future<void> atualizarPerfilFotoBase64({
  required String base64String,
}) async {
  if (_usuarioAtual == null) return;
  
  final fotoPath = 'data:image/jpeg;base64,$base64String';
  
  _usuarioAtual = _usuarioAtual!.copyWith(
    fotoPath: fotoPath,
    ultimoAcesso: DateTime.now(),
  );
  
  await DatabaseService.salvarUsuario(_usuarioAtual!);
  notifyListeners();
}
  
  Future<void> atualizarEstatisticas({
    int? novasListas,
    int? novosItens,
    double? novoGasto,
  }) async {
    if (_usuarioAtual == null) return;
    
    final novasEstatisticas = _usuarioAtual!.estatisticas.copyWith(
      totalListasCriadas: _usuarioAtual!.estatisticas.totalListasCriadas + (novasListas ?? 0),
      totalItensComprados: _usuarioAtual!.estatisticas.totalItensComprados + (novosItens ?? 0),
      totalGasto: _usuarioAtual!.estatisticas.totalGasto + (novoGasto ?? 0),
      ultimaCompra: novoGasto != null ? DateTime.now() : _usuarioAtual!.estatisticas.ultimaCompra,
    );
    
    _usuarioAtual = _usuarioAtual!.copyWith(
      estatisticas: novasEstatisticas,
    );
    
    await DatabaseService.salvarUsuario(_usuarioAtual!);
    notifyListeners();
  }
}